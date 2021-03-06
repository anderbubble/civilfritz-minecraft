#!/bin/sh
# Start/stop the minecraft server.
#
### BEGIN INIT INFO
# Provides:          minecraft
# Required-Start:
# Required-Stop:
# Should-Start:
# Should-Stop:
# Default-Start:     2 3 4 5
# Default-Stop:
# Short-Description: Minecraft multiplayer server
# Description:       Minecraft is a game about breaking and 
#                    placing blocks. At first, people built
#                    structures to protect against nocturnal
#                    monsters, but as the game grew players
#                    worked together to create wonderful,
#                    imaginative things.
### END INIT INFO


PIDFILE=/var/run/minecraft/minecraft_server.pid

test -f /usr/bin/minecraft_server || exit 0

if test -f /etc/default/minecraft; then
    . /etc/default/minecraft
fi

. /lib/lsb/init-functions

if [ ! -z "${MEMORY_INIT}" ]
then
    XMS="-Xms${MEMORY_INIT}"
fi

if [ ! -z "${MEMORY_MAX}" ]
then
    XMX="-Xmx${MEMORY_MAX}"
fi


start_server ()
{
    start-stop-daemon --start --quiet \
        --user minecraft --chuid minecraft \
        --background --pidfile $PIDFILE --make-pidfile \
        --chdir /var/lib/minecraft --startas /usr/bin/minecraft_server --name java \
        -- -Xincgc $XMS $XMX $EXTRA_OPTS
}


stop_server ()
{
    local pid=$(cat ${PIDFILE})
    local interval
    echo '/stop' >/var/run/minecraft/minecraft_server
    for interval in 1 2 5
    do
        check_server_status || return 0
        log_progress_msg .
        sleep $interval
    done
    return 1
}


kill_server ()
{
    start-stop-daemon --stop --retry 5 --quiet --user minecraft --pidfile $PIDFILE --name java
}


restart_server ()
{
    stop_server && start_server
}


reload_server ()
{
    echo '/reload' >/var/run/minecraft/minecraft_server
}


check_server_status ()
{
    pidofproc -p "$PIDFILE" >/dev/null
}


case "$1" in
    start)
        log_daemon_msg "Starting Minecraft server"
        start_server
        log_action_end_msg $?
        ;;
    stop)
        log_daemon_msg "Stopping Minecraft server"
        stop_server
        log_action_end_msg $?
        ;;
    kill)
        log_daemon_msg "Killing Minecraft server"
        kill_server
        log_action_end_msg 0
        ;;
    restart)
        log_daemon_msg "Restarting Minecraft server"
        restart_server
        log_action_end_msg $?
        ;;
    reload)
        log_daemon_msg "Reloading configuration files for Minecraft server"
        reload_server
        log_action_end_msg 0
        ;;
    status)
        log_action_begin_msg "Checking Minecraft server"
        if check_server_status; then
            log_action_end_msg 0 "running"
            exit 0
        else
            log_action_end_msg 0 "not running"
            exit 3
        fi
        ;;
    *)	log_action_msg "Usage: /etc/init.d/minecraft {start|stop|kill|status|restart|reload}"
        exit 2
        ;;
esac
exit 0
