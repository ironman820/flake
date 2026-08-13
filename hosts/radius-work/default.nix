{
  config,
  flakeRoot,
  pkgs,
  self,
  ...
}:
{
  imports = [
    ./hardware.nix
  ]
  ++ (with self.nixosModules; [
    proxmox
    x64-linux
  ]);
  environment = {
    etc."raddb" = {
      group = "radius";
      source =
        let
          pkg = pkgs.freeradius;
          clientConf = pkgs.writeText "clients.conf" ''
            client desk-router {
              ipaddr = 192.168.20.1
              secret = testing123
              require_message_authenticator = true
            }
          '';
          eapConf = pkgs.writeText "eap" ''
            eap {
              default_eap_type = md5
              timer_expire = 60
              ignore_unknown_eap_types = no
              cisco_accounting_username_bug = no
              max_sessions = ''${max_requests}
              md5 {
              }
              gtc {
                auth_type = PAP
              }
              tls-config tls-common {
                # private_key_password = whatever
                private_key_file = ''${certdir}/server.pem
                certificate_file = ''${certdir}/server.pem
                # ca_file = ''${cadir}/ca.pem
                # ca_path = ''${cadir}
                cipher_list = "DEFAULT"
                cipher_server_preference = no
                tls_min_version = "1.2"
                tls_max_version = "1.2"
                ecdh_curve = ""
                cache {
                  enable = no
                  lifetime = 24 # hours
                  store {
                    Tunnel-Private-Group-Id
                  }
                }
                verify {
                }
                ocsp {
                  enable = no
                  override_cert_url = yes
                  url = "http://127.0.0.1/ocsp/"
                }
              }
              tls {
                tls = tls-common
              }
              ttls {
                tls = tls-common
                default_eap_type = md5
                copy_request_to_tunnel = no
                use_tunneled_reply = no
                virtual_server = "inner-tunnel"
              }
              peap {
                tls = tls-common
                default_eap_type = mschapv2
                copy_request_to_tunnel = no
                use_tunneled_reply = no
                virtual_server = "inner-tunnel"
              }
              mschapv2 {
              }
            }
          '';
          filesConf = pkgs.writeText "files" ''
            files {
              moddir = ''${modconfdir}/''${.:instance}
              filename = ''${moddir}/authorize
              match_attr = NAS-IP-Address
              acctusersfile = ''${moddir}/accounting
              preproxy_usersfile = ''${moddir}/pre-proxy
            }
          '';
          radiusConf = pkgs.writeText "radiusd.conf" ''
            prefix = ${pkg}
            exec_prefix = ''${prefix}
            sysconfdir = /etc
            localstatedir = /var
            sbindir = "${pkg}/sbin"
            logdir = ''${localstatedir}/log/radius
            raddbdir = ''${sysconfdir}/raddb
            radacctdir = ''${logdir}/radacct

            name = radiusd

            confdir = ''${raddbdir}
            modconfdir = ''${confdir}/mods-config
            certdir = ''${confdir}/certs
            cadir   = ''${confdir}/certs
            run_dir = ''${localstatedir}/run/''${name}

            # Should likely be ''${localstatedir}/lib/radiusd
            db_dir = ''${raddbdir}

            libdir = "${pkg}/lib"

            pidfile = ''${run_dir}/''${name}.pid
            max_request_time = 30
            cleanup_delay = 5
            max_requests = 16384
            hostname_lookups = no

            unlang {
            }
            log {
              destination = files
              colourise = yes
              file = ''${logdir}/radius.log
              syslog_facility = daemon
              stripped_names = no
              auth = yes
              auth_badpass = no
              auth_goodpass = no
              msg_denied = "You are already logged in - access denied"
            }
            checkrad = ''${sbindir}/checkrad
            ENV {
            }
            security {
              allow_core_dumps = no
              max_attributes = 200
              reject_delay = 1
              status_server = yes
              require_message_authenticator = auto
              limit_proxy_state = auto
              allow_vulnerable_openssl = no
            }
            proxy_requests  = yes
            $INCLUDE proxy.conf
            $INCLUDE clients.conf
            thread pool {
              start_servers = 5
              max_servers = 32
              min_spare_servers = 3
              max_spare_servers = 10
              max_requests_per_server = 0
              auto_limit_acct = no
            }
            modules {
              $INCLUDE mods-enabled/
            }
            instantiate {
            }
            policy {
              $INCLUDE policy.d/
            }
            $INCLUDE sites-enabled/
          '';
          userConf = pkgs.writeText "users" ''
            D2:C1:25:62:6D:33 Auth-Type := Accept
              Framed-IP-Address := 192.168.21.5
          '';
          netboxClients = pkgs.writeText "netbox_clients.py" ''
            import radiusd
            import pynetbox
            import os

            url = os.environ.get('NETBOX_URL')
            token = os.environ.get('NETBOX_TOKEN')

            nb    = pynetbox.api(url, token=token)

            def instantiate(p):
              print("*** instantiate ***")
              radiusd.radlog(radiusd.L_INFO, '*** netbox_clients instantiate ***')
              print(p)

            def authorize(p):
              print("*** authorize ***")
              radiusd.radlog(radiusd.L_INFO, '*** radlog call in authorize ***')

              # check to have an IP address
              for avpair in p['request']:
                (attribute, value) = avpair
                if (attribute=="FreeRADIUS-Client-IP-Address"):
                  address = value

              # Get information for that address from netbox
              try:
                  nbaddress = nb.ipam.ip_addresses.get(address=address)
              except:
                  radiusd.radlog(radiusd.L_INFO, f"*** NETBOX: Unable to find IP address... Dropping packet ***")
                  return radiusd.RLM_MODULE_REJECT

              # Fail if IP address unknown to netbox
              if not nbaddress:
                  radiusd.radlog(radiusd.L_INFO, f"*** NETBOX: Address not found... Dropping packet ***")
                  return radiusd.RLM_MODULE_REJECT

              # Get information abount the device.
              try:
                  nbdevice = nb.dcim.devices.get(name=nbaddress.assigned_object.device.name)
              except:
                  radiusd.radlog(radiusd.L_INFO, f"*** NETBOX: Address not associated to device... Dropping packet ***")
                  return radiusd.RLM_MODULE_REJECT

              # Known device. Update the shared secret from config_context of the device.
              try:
                  nbdevice['custom_fields']['radius_secret']
              except:
                  radiusd.radlog(radiusd.L_INFO, f"*** NETBOX: Device does not have a shared secret... Dropping packet ***")
                  return radiusd.RLM_MODULE_REJECT

              _nas_type = "other"
              try:
                  if nbdevice['config_context']['nas-type']:
                      _nas_type = nbdevice['config_context']['nas-type']
                      radiusd.radlog(radiusd.L_INFO, f"*** NETBOX: NAS-Type found, using {_nas_type} ***")
              except:
                  radiusd.radlog(radiusd.L_INFO, f"*** NETBOX: NAS-Type not found, using other ***")

              update_dict = {
                "config": ( ('FreeRADIUS-Client-Secret', nbdevice['custom_fields']['radius_secret']),
                            ('FreeRADIUS-Client-Shortname', nbdevice['name']),
                            ('FreeRADIUS-Client-NAS-Type', _nas_type), ),
              }
              return radiusd.RLM_MODULE_OK, update_dict

            def detach(p):
              print("*** goodbye from dynclients.py ***")
              return radiusd.RLM_MODULE_OK
          '';
        in
        pkgs.symlinkJoin {
          name = "raddb";
          paths = [ "${pkg}/etc/raddb" ];
          postBuild = ''
            rm -f $out/clients.conf
            rm -f $out/radiusd.conf
            rm -f $out/users
            rm -f $out/certs/server.pem
            rm -f $out/mods-config/files/authorize
            rm -r $out/mods-enabled/eap
            rm -r $out/mods-enabled/files

            ln -s ${clientConf} $out/clients.conf
            ln -s ${radiusConf} $out/radiusd.conf
            ln -s ${userConf} $out/mods-config/files/authorize
            mkdir -p $out/mods-config/python3
            ln -s ${netboxClients} $out/mods-config/python3/netbox_clients.py
            ln -s ${config.sops.secrets."server.pem".path} $out/certs/server.pem
            ln -s ${eapConf} $out/mods-enabled/eap
            ln -s ${filesConf} $out/mods-enabled/files
          '';
        };
      user = "radius";
    };
    systemPackages = let
      pythonPackages = pkgs.python3.withPackages (py: with py; [
          autopep8
          black
          cffi
          click
          dbus-next
          debugpy
          flake8
          isort
          jedi
          jedi-language-server
          jsonrpc-base
          mypy
          pdfplumber
          pip
          pre-commit-hooks
          psutil
          pygobject3
          pynetbox
          pymupdf
          pynvim
          pytest
          pytest-expect
          pytest-lazy-fixture
          pytest-raises
          pytest-tornado
          pyvirtualdisplay
          qtile
          rich
          rope
          typing-extensions
          typing-inspect
          xcffib
      ]);
    in
    with pkgs; [
      freeradius
      pythonPackages
    ];
  };
  home-manager = {
    users.ironman = self.homeConfigurations.ironman-server;
  };
  networking.firewall.allowedUDPPorts = [
    1812
  ];
  nix.settings.cores = 1;
  security.sudo.wheelNeedsPassword = false;
  services = {
    freeradius.enable = true;
    openssh.settings.PermitRootLogin = "no";
    qemuGuest.enable = true;
  };
  sops.secrets."server.pem" = {
    owner = "radius";
    group = "radius";
    sopsFile = "${flakeRoot}/.secrets/radius.yaml";
    restartUnits = [ "freeradius.service" ];
  };
  users.users.ironman.extraGroups = [
    "networkmanager"
  ];
}
