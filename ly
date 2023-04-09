#!/sbin/openrc-run

name="ly"
description="TUI Display Manager"

## Supervisor daemon
supervisor=supervise-daemon
respawn_period=60
pidfile=/run/"${RC_SVCNAME}.pid"

## Check for getty or agetty
if [ -x /sbin/getty ] || [ -x /bin/getty ];
then
    # busybox
    commandB="/sbin/getty"
elif [ -x /sbin/agetty ] || [ -x /bin/agetty ];
then
    # util-linux
    commandUL="/sbin/agetty"
fi

## Get the tty from the conf file
CONFTTY=$(cat /etc/ly/config.ini | sed -n 's/^tty.*=[^1-9]*// p')

## The execution vars
# If CONFTTY is empty then default to 2
TTY="tty${CONFTTY:-2}"
TERM=linux
BAUD=38400
# If we don't have getty then we should have agetty
command=${commandB:-$commandUL}
command_args_foreground="-nl /usr/bin/ly $TTY $BAUD $TERM ; plymouth --quit"

depend() {
         after agetty #agetty.tty1 plymouth-deactivate plymouth-quit
	 use plymouth-deactivate
         provide display-manager xdm
         want elogind
}
