#!/usr/bin/env python3

"""
Dell iDRAC client launcher for Linux, macOS and Windows.
probably works with Dell iDRAC 6/7/8

Downloads needed Java files and sets up port forwarding via SSH.

example usage: ./idracclient.py -J jumphost.lol.domain srv42-serviceprocessor.lol.domain
for more info, see ./idracclient.py --help

* use python3.6 or later!
* use java 8 (jre 1.8)!

(c) 2018-2019 Jonas Jelten <jelten@in.tum.de>
Released under GNU GPLv3 or any later version
"""

import argparse
import asyncio
import getpass
import os
import pathlib
import socket
import ssl
import subprocess
import sys
import zipfile

import aiohttp


def main():
    cmd = argparse.ArgumentParser()
    cmd.add_argument("hostname")
    cmd.add_argument(
        "--port", "-p", type=int, default=443, help="https port to connect to for idrac"
    )
    cmd.add_argument(
        "--kvmport", "-k", type=int, default=5900, help="port for the kvm connection"
    )
    cmd.add_argument(
        "--basedir",
        "-b",
        default="/tmp/idracvm",
        help="base directory where to put in state and downloaded stuff",
    )
    cmd.add_argument(
        "--java", default="java", help="custom location for the java executable"
    )
    cmd.add_argument("--username", "-u", default="root", help="idrac login username")
    cmd.add_argument(
        "--tlscheck",
        action="store_true",
        help="do certificat validation which is disabled by default",
    )
    cmd.add_argument(
        "--force-download",
        "-f",
        action="store_true",
        help="re-download kvm viewer files and libraries",
    )
    cmd.add_argument(
        "--dryrun",
        action="store_true",
        help="don't actually run the viewer, but to everything else",
    )
    cmd.add_argument(
        "--jumphost",
        "-J",
        help="use this jumphost for relaying the connection via ssh port forwards",
    )
    cmd.add_argument(
        "--jumpkvmport",
        type=int,
        default=0,
        help="port for kvm listened on localhost by ssh",
    )
    cmd.add_argument(
        "--jumphttpport",
        type=int,
        default=0,
        help="port for idrac webinterface listened on localhost by ssh",
    )
    cmd.add_argument(
        "--sshtimeout",
        type=int,
        default=8,
        help="timeout for establishing the ssh jump host connection",
    )
    cmd.add_argument(
        "--no-native-libs",
        action="store_true",
        help="don't download the native libraries for input and device redirecions",
    )

    args = cmd.parse_args()

    loop = asyncio.get_event_loop()
    ret = loop.run_until_complete(run(args))

    sys.exit(ret)


async def download(url, check_tls=True):
    async with aiohttp.ClientSession() as session:
        tls_settings = ssl.create_default_context()
        # the crappy iDRACs have slightly outdated crypto...
        tls_settings.set_ciphers("ALL:!aNULL:!DH")

        if not check_tls:
            tls_settings.check_hostname = False
            tls_settings.verify_mode = ssl.CERT_NONE

        async with session.get(url, ssl=tls_settings) as resp:
            return await resp.read()


async def download_all(
    mainjar, libdir, hostname, port, tlscheck=True, use_native_libs=True
):
    print("downloading files...")
    with mainjar.open("wb") as fd:
        content = await download(
            "https://%s:%d/software/avctKVM.jar" % (hostname, port), tlscheck
        )
        fd.write(content)

    if use_native_libs:
        if sys.platform == "linux":
            libdls = ["avctKVMIOLinux64.jar", "avctVMLinux64.jar"]
            extension = ".so"
        elif sys.platform == "darwin":
            libdls = ["avctKVMIOMac64.jar", "avctVMMac64.jar"]
            extension = ".jnilib"
        elif sys.platform == "win32":
            libdls = ["avctKVMIOWin64.jar", "avctVMWin64.jar"]
            extension = ".dll"
        else:
            raise Exception("running on unknown platform: %s" % sys.platform)

        for dlname in libdls:
            dl_lib = libdir / dlname
            try:
                with dl_lib.open("wb") as fd:
                    content = await download(
                        "https://%s:%d/software/%s" % (hostname, port, dlname), tlscheck
                    )
                    fd.write(content)
            except aiohttp.ClientError:
                os.unlink(dl_lib)
                raise

            zf = zipfile.ZipFile(str(dl_lib))
            zf.extractall(str(libdir))

    print("finished downloading files.")


async def create_sec_override(path):
    # write funny security overwrite file
    with path.open("w") as fd:
        fd.write("# iDRAC uses disabled, outdated crypto\n")
        fd.write("# we override the disabled algos to enable 3DES_EDE_CBC and SSLv3\n")
        fd.write(
            "jdk.tls.disabledAlgorithms=RC4, DES, MD5withRSA, DH keySize < 1024, EC keySize < 224\n"
        )


def find_port(blacklist=[]):
    port = 9009
    sock = socket.socket()
    while True:
        port += 1
        while port in blacklist:
            port += 1

        try:
            sock.bind(("", port))
            sock.close()
            break

        except OSError:
            pass

    return port


async def run(args):
    basedir = pathlib.Path(args.basedir)
    hostdir = basedir / args.hostname
    libdir = hostdir / "lib"
    libdir.mkdir(parents=True, exist_ok=True)

    java_kvmhost = args.hostname
    java_kvmport = args.kvmport
    java_idracport = args.port

    # jumphost setup
    if args.jumphost:
        if args.jumphttpport:
            jumpkvmport = args.jumphttpport
        else:
            jumpkvmport = find_port()

        if args.jumphttpport:
            jumphttpport = args.jumphttpport
        else:
            jumphttpport = find_port([jumpkvmport])

        print("launching port forwarding...")
        forward_invocation = [
            "ssh",
            "-S",
            "none",
            "-L",
            "%d:%s:%d" % (jumphttpport, args.hostname, args.port),
            "-L",
            "%d:%s:%d" % (jumpkvmport, args.hostname, args.kvmport),
            args.jumphost,
            "echo kay && cat",
        ]
        print("$ %s" % " ".join(forward_invocation))
        sshproc = await asyncio.create_subprocess_exec(
            *forward_invocation, stdout=subprocess.PIPE
        )

        # wait until "kay" appears
        try:
            await asyncio.wait_for(
                sshproc.stdout.readuntil(b"kay\n"), timeout=args.sshtimeout
            )
        except asyncio.TimeoutError as exc:
            raise Exception("failed to set up port forwards via ssh") from exc

        print("port forwards established.")

        # now java has to connect to localhost
        java_kvmhost = "localhost"
        java_kvmport = jumpkvmport
        java_idracport = jumphttpport

    # download java files
    mainjar = hostdir / "avctKVM.jar"
    if not (mainjar.is_file() and mainjar.stat().st_size) or args.force_download:
        await download_all(
            mainjar,
            libdir,
            java_kvmhost,
            java_idracport,
            args.tlscheck,
            not args.no_native_libs,
        )
    else:
        print("no need to download files")

    # create security override for SSLv3
    sec_overwrite_path = hostdir / "java_security_overrides"
    await create_sec_override(sec_overwrite_path)

    # query password
    if args.dryrun:
        password = "xxx-dryrun-xxx"
    else:
        password = getpass.getpass("enter idrac password: ")

    print("launching viewer...")

    invocation = [
        args.java,
        "-cp",
        str(mainjar),
    ]

    if not args.no_native_libs:
        invocation.append("-Djava.library.path=%s" % libdir)

    invocation.extend(
        [
            # single = means overwrite only parts, == means overwrite all:
            "-Djava.security.properties=%s" % sec_overwrite_path,
            "com.avocent.idrac.kvm.Main",
            "ip=%s" % java_kvmhost,
            "kmport=%d" % java_kvmport,
            "vport=%d" % java_kvmport,
            "user=%s" % args.username,
            "passwd=%s" % password,
            "apcp=1",
            "version=2",
            "reconnect=2",
            "vmprivilege=true",
            "helpurl=https://%s:%d/help/contents.html" % (java_kvmhost, java_idracport),
        ]
    )

    print("$ %s" % " ".join(invocation))

    if args.dryrun:
        ret = 0
    else:
        proc = await asyncio.create_subprocess_exec(*invocation)

        ret = await proc.wait()

    if args.jumphost:
        sshproc.terminate()
        await sshproc.wait()

    return ret


if __name__ == "__main__":
    main()
