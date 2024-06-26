local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local extras = require("luasnip.extras")
local l = extras.lambda
local rep = extras.rep
local p = extras.partial
local m = extras.match
local n = extras.nonempty
local dl = extras.dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local conds = require("luasnip.extras.expand_conditions")
local postfix = require("luasnip.extras.postfix").postfix
local types = require("luasnip.util.types")
local parse = require("luasnip.util.parser").parse_snippet
local ms = ls.multi_snippet
local k = require("luasnip.nodes.key_indexer").new_key

ls.add_snippets("nix", {
  s(
    "nixhome",
    fmt(
      [[
        {{
            # Snowfall Lib provides a customized `lib` instance with access to your flake's library
            # as well as the libraries available from your flake's inputs.
            lib,
            # An instance of `pkgs` with your overlays and packages applied is also available.
            pkgs,
            # You also have access to your flake's inputs.
            inputs,

            # Additional metadata is provided by Snowfall Lib.
            home, # The home architecture for this host (eg. `x86_64-linux`).
            target, # The Snowfall Lib target for this home (eg. `x86_64-home`).
            format, # A normalized name for the home target (eg. `home`).
            virtual, # A boolean to determine whether this home is a virtual target using nixos-generators.
            host, # The host name for this home.

            # All other arguments come from the home home.
            config,
            ...
        }}:
        {{
          {}
        }}
      ]],
      {
        i(0),
      }
    )
  ),
  s(
    "nixmod",
    fmt(
      [[
        {{
            # Snowfall Lib provides a customized `lib` instance with access to your flake's library
            # as well as the libraries available from your flake's inputs.
            lib,
            # An instance of `pkgs` with your overlays and packages applied is also available.
            pkgs,
            # You also have access to your flake's inputs.
            inputs,

            # Additional metadata is provided by Snowfall Lib.
            system, # The system architecture for this host (eg. `x86_64-linux`).
            target, # The Snowfall Lib target for this system (eg. `x86_64-iso`).
            format, # A normalized name for the system target (eg. `iso`).
            virtual, # A boolean to determine whether this system is a virtual target using nixos-generators.
            systems, # An attribute map of your defined hosts.

            # All other arguments come from the module system.
            config,
            ...
        }}: let
          inherit (lib) mkEnableOption mkIf;

          cfg = config.mine.{};
        in {{
          options.mine.{} = {{
            enable = mkEnableOption "Enable the module";
          }};
          config = mkIf cfg.enable {{
            {}
          }};
        }}
      ]],
      {
        i(1, "module"),
        rep(1),
        i(0),
      }
    )
  ),
  s(
    "nixpkg",
    fmt(
      [[
      {{ lib, inputs, pkgs, stdenv, ... }}:

      stdenv.mkDerivation {{
        name = "{}";
        version = "{}";
        {}
      }}
      ]],
      {
        i(1, "name"),
        i(2, "version"),
        i(0),
      }
    )
  ),
  s(
    "nixoverlay",
    fmt(
      [[
        # Snowfall Lib provides access to your current Nix channels and inputs.
        #
        # Channels are named after NixPkgs instances in your flake inputs. For example,
        # with the input `nixpkgs` there will be a channel available at `channels.nixpkgs`.
        # These channels are system-specific instances of NixPkgs that can be used to quickly
        # pull packages into your overlay.
        #
        # All other arguments for this function are your flake inputs.
        {{ channels, ... }}:

        final: prev: {{
            {}
        }}
      ]],
      {
        i(0),
      }
    )
  ),
  s(
    "nixvimplug",
    fmt(
      [[
      {{ inputs, pkgs, ... }}:
      let inherit (pkgs.vimUtils) buildVimPlugin;
      in buildVimPlugin {{
        name = "{}";
        src = inputs.{};
      }}
      ]],
      {
        i(1, "name"),
        i(0, "input"),
      }
    )
  ),
  s(
    "nixsys",
    fmt(
      [[
      {{
          # Snowfall Lib provides a customized `lib` instance with access to your flake's library
          # as well as the libraries available from your flake's inputs.
          lib,
          # An instance of `pkgs` with your overlays and packages applied is also available.
          pkgs,
          # You also have access to your flake's inputs.
          inputs,
          # Additional metadata is provided by Snowfall Lib.
          system, # The system architecture for this host (eg. `x86_64-linux`).
          target, # The Snowfall Lib target for this system (eg. `x86_64-iso`).
          format, # A normalized name for the system target (eg. `iso`).
          virtual, # A boolean to determine whether this system is a virtual target using nixos-generators.
          systems, # An attribute map of your defined hosts.
          # All other arguments come from the system system.
          config,
          ...
      }}:
      {{
          {}
      }}
      ]],
      {
        i(0),
      }
    )
  ),
})
