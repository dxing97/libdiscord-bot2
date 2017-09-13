#!/bin/bash
#dependency installer for libdiscord bot2
#eventually it'll also install libdiscord itself as well as any bots but for now it just takes care of dependencies

#supported distributions:
#Ubuntu 17.04 on x86_64
#todo: test Debian on Raspberry Pi, CentOS on x86, SunOS on SPARC (especially CentOS and SunOS. Can't apt your way through those...)

OS=$(lsb_release -si)
VER=$(lsb_release -sr)

case $OS in
    "Ubuntu")
        #echo Detected Ubuntu
        case $VER in
            "17.04")
                echo Detected supported $OS version \($VER\)
            ;;
            *)
                echo This version of $OS \($VER\) is not supported. Installation might not work.
                read -rsp $'Press any key to contunue\n' -n1 key
            ;;
        esac
    ;;
    "Debian")
        case $VER in
            "9.0.0" | "9.0.1")
                echo Detected supported $OS version \($VER\)
            ;;
            *)
                echo This version of $OS \($VER\) is not supported. Installation might not work.
                read -rsp $'Press any key to contunue\n' -n1 key
            ;;
#    "Elementary OS")
#        echo Detected Elementary OS
#        case $VER in
#            "1.0")
#                echo Detected supported $OS version \($VER\)
        esac
esac
	 
sudo apt update && sudo apt upgrade
sudo apt install checkinstall libmicrohttpd-dev libjansson-dev libcurl4-gnutls-dev libgnutls28-dev libgcrypt20-dev git make cmake gcc libssl-dev libuv-dev libconfig-dev
cd ~/

#build from source and install ulfius and dependencies
git clone https://github.com/babelouest/ulfius.git
cd ulfius/
git submodule update --init
cd lib/orcania
make && sudo checkinstall
cd ../yder
make && sudo checkinstall
cd ../..
make
sudo checkinstall
cd ..

#build from source and install libwebsockets
git clone https://github.com/warmcat/libwebsockets
cd libwebsockets
mkdir build
cd build 
cmake ..
make
sudo checkinstall --pkgname libwebsockets
sudo ldconfig

#compile client 
#gcc -lwebsockets -lssl -lcrypto test-client.c -lwebsockets -lssl -lcrypto

#todo: detect if ulfius and libwebsockets are already installed
#todo: detect the version of different dependencies to make sure they work
#todo: add bot2 compilation and installation here as well
