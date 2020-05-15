#! /bin/sh

PUMA_CONFIG_FILE=/home/panchuk/eleway/config/puma.rb
PUMA_PID_FILE=/home/panchuk/var/pids/puma.pid
PUMA_SOCKET=/var/run/puma/puma.sock


#janus
. /lib/lsb/init-functions
DAEMON=/opt/janus/bin/janus
NAME=janus
DESC=Webrtc_Gateway
PIDFILE=/home/panchuk/var/pids/janus.pid
LOGFILE=/home/panchuk/var/log/janus.log
OPTIONS=


# check if puma process is running
puma_is_running() {
  if [ -e $PUMA_SOCKET ] ; then
    if [ -r $PUMA_PID_FILE ] ; then
       if ps -p `cat $PUMA_PID_FILE` > /dev/null; then
        return 0
      else
        echo "No puma process found"
      fi
    else
      echo "No puma pid file found"
    fi
  else
    echo "No puma socket found"
  fi

  return 1
}


start() {
    echo "Starting puma..."
      if [ -e $PUMA_SOCKET  ] ; then # if socket exists
        rm -f $PUMA_SOCKET
        echo "removed $PUMA_SOCKET"
      fi
      if [ -e $PUMA_CONFIG_FILE ] ; then
        echo "config"
        bundle exec puma -C $PUMA_CONFIG_FILE

      else
        echo "socket"
        bundle exec puma --daemon --bind unix://$PUMA_SOCKET --pidfile $PUMA_PID_FILE
      fi

    echo "Puma started"

    #janus
     PID=`ps -ef | grep $DAEMON | grep -v grep | awk '{print $2}'`
     if  [ -n "$PID" ];  then
        log_failure_msg "$DESC is allready running on PID $PID, please use restart option"
        exit 1
     fi
     sudo  rm -f $PIDFILE
     log_daemon_msg "Starting $DESC" "$NAME"
     sudo start-stop-daemon --start --quiet --background --make-pidfile --pidfile $PIDFILE --exec /bin/bash -- -c "exec $DAEMON $OPTIONS >> $LOGFILE"
     log_end_msg $?
     echo "Janus Started"
}

stop() {
    echo "Stopping puma..."
      kill -9 `cat $PUMA_PID_FILE`
      rm -f $PUMA_PID_FILE
      rm -f $PUMA_SOCKET

    echo "Puma stoped"

    #janus
    log_daemon_msg "Stopping $DESC" "$NAME"
    sudo start-stop-daemon  --stop  --pidfile $PIDFILE --retry  10
    log_end_msg $?
    sudo rm -f $PIDFILE
    echo "Janus stoped"

}

case "$1" in
  start)
    start
    ;;

  stop)
    stop
    ;;

  restart)
    stop
    start
    ;;

  *)
    echo "Usage: script/puma.sh {start|stop|restart}" >&2
    ;;
esac


