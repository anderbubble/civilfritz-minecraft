#!/bin/bash

if [[ -t 0 ]]
then
    exec java -jar /usr/lib/minecraft/minecraft_server.jar $@
else
    if [[ ! -p /var/run/minecraft/minecraft_server ]]
    then
        mkfifo /var/run/minecraft/minecraft_server
    fi
    exec java -jar /usr/lib/minecraft/minecraft_server.jar $@ <>/var/run/minecraft/minecraft_server
fi
