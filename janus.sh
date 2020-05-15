#!/bin/sh

### BEGIN INIT INFO
# Provides:          janus
# Required-Start:    $syslog $network $local_fs $time
# Required-Stop:     $syslog $network $local_fs
# Should-Start:
# Should-Stop:
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start the Janus WEBRTC gateway
# Description:       Start the Janus WEBRTC gateway
### END INIT INFO

#PATH=/sbin:/bin:/usr/sbin:/usr/bin
. /lib/lsb/init-functions
DAEMON=/opt/janus/bin/janus
NAME=janus
DESC=Webrtc_Gateway
HOMEDIR=/var/run

#PIDFILE=$HOMEDIR/$NAME.pid
PIDFILE=/home/panchuk/var/pids/janus.pid
DEFAULTS=/etc/default/opensips
LOGFILE=/home/panchuk/var/log/janus.log
OPTIONS=


test -f $DAEMON || exit 0
set -e

case $1 in
  start)

        PID=`ps -ef | grep $DAEMON | grep -v grep | awk '{print $2}'`
        if  [ -n "$PID" ];  then
                log_failure_msg "$DESC is allready running on PID $PID, please use restart option"
                exit 1
        fi
        sudo rm -f $PIDFILE
        log_daemon_msg "Starting $DESC" "$NAME"
        sudo start-stop-daemon --start --quiet --background --make-pidfile --pidfile $PIDFILE --exec /bin/bash -- -c "exec $DAEMON $OPTIONS >> $LOGFILE"
        log_end_msg $?
        ;;
  stop)
        log_daemon_msg "Stopping $DESC" "$NAME" "$PIDFILE"
       	sudo start-stop-daemon --stop --pidfile $PIDFILE --retry 10
	log_end_msg $?
        sudo rm -f $PIDFILE
        ;;
  kill)
        log_daemon_msg "killing $DESC" "$NAME"

        sudo start-stop-daemon --stop --pidfile $PIDFILE -retry 10
        log_end_msg $?
        sudo rm -f $PIDFILE
        ;;
  restart)
        $0 stop && sleep 5 && $0 start
        ;;
  status)
        status_of_proc $DAEMON $DESC
        ;;
  *)
        N=/etc/init.d/$NAME
        echo "Usage: $N {start|stop|restart|status|kill}"
        exit 2
        ;;
esac
