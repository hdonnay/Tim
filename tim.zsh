#!/usr/bin/env zsh
# vim: ft=zsh noet sw=4 ts=4

# Copyright (c) 2011, Göran Gustafsson. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
#  Redistributions of source code must retain the above copyright notice, this
#  list of conditions and the following disclaimer.
#
#  Redistributions in binary form must reproduce the above copyright notice,
#  this list of conditions and the following disclaimer in the documentation
#  and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

###############################################################################
# Web: http://ggustafsson.github.com/Timer-Script-Improved                    #
# Git: https://github.com/ggustafsson/Timer-Script-Improved                   #
###############################################################################

VERSION=1.0.2
FILENAME=$0:t # Get filename from full path.
DIRECTORY=$0:A:h # Directory the script is in.

CMD_SETTINGS=(TIMER_CMD WORK_CMD BREAK_CMD POMODORO_CMD)
RPT_SETTINGS=(TIMER_REPEAT_ALARM POMODORO_REPEAT_ALARM)
INT_SETTINGS=(INTERVAL POMODORO_WORK POMODORO_BREAK POMODORO_STOP)


###############################################################################
# CONFIGURATION SECTION                                                       #
###############################################################################
[ -f ~/.timrc ] && source ~/.timrc # Lazy fix. This is just temporary.

if [[ $OSTYPE == darwin* ]]; then
	DEFAULT_CMD=afplay # Comes with Mac OS X.
else
	DEFAULT_CMD="aplay -q" # Comes with alsa-utils.
fi

# If these variables are not found in ~/.timrc then set them. Tim checks for
# audio files in this order: 1. ~/.timrc, 2. ~/.tim folder and 3. script $PWD.
if [ -z $TIMER_CMD ]; then
	if [ -f ~/.tim/alarm.wav ]; then
		TIMER_CMD="$DEFAULT_CMD ~/.tim/alarm.wav"
	elif [ -f $DIRECTORY/audio_files/alarm.wav ]; then
		TIMER_CMD="$DEFAULT_CMD $DIRECTORY/audio_files/alarm.wav"
	else
		FILE_ERROR=1
	fi
fi

if [ -z $WORK_CMD ]; then
	if [ -f ~/.tim/work.wav ]; then
		WORK_CMD="$DEFAULT_CMD ~/.tim/work.wav"
	elif [ -f $DIRECTORY/audio_files/work.wav ]; then
		WORK_CMD="$DEFAULT_CMD $DIRECTORY/audio_files/work.wav"
	else
		FILE_ERROR=1
	fi
fi

if [ -z $BREAK_CMD ]; then
	if [ -f ~/.tim/break.wav ]; then
		BREAK_CMD="$DEFAULT_CMD ~/.tim/break.wav"
	elif [ -f $DIRECTORY/audio_files/break.wav ]; then
		BREAK_CMD="$DEFAULT_CMD $DIRECTORY/audio_files/break.wav"
	else
		FILE_ERROR=1
	fi
fi

if [ -z $POMODORO_CMD ]; then
	if [ -f ~/.tim/alarm.wav ]; then
		POMODORO_CMD="$DEFAULT_CMD ~/.tim/alarm.wav"
	elif [ -f $DIRECTORY/audio_files/alarm.wav ]; then
		POMODORO_CMD="$DEFAULT_CMD $DIRECTORY/audio_files/alarm.wav"
	else
		FILE_ERROR=1
	fi
fi

[ -z $TIMER_REPEAT_ALARM    ] && TIMER_REPEAT_ALARM=0
[ -z $POMODORO_REPEAT_ALARM ] && POMODORO_REPEAT_ALARM=0

[ -z $POMODORO_WORK  ] && POMODORO_WORK=25
[ -z $POMODORO_BREAK ] && POMODORO_BREAK=5
[ -z $POMODORO_STOP  ] && POMODORO_STOP=4

[ -z $INTERVAL ] && INTERVAL=15


###############################################################################
# VALIDATE SETTINGS SECTION                                                   #
###############################################################################
function validate_settings {
	a=(${(z)DEFAULT_CMD}) # Put value of DEFAULT_CMD in array.

	if ! $(type -p $a[1] > /dev/null); then # Exists command?
		if [[ $1 == debug ]]; then
			echo "DEFAULT_CMD: Command '$a[1]' doesn't exist!" && ERROR=1
		else
			echo "Tim wants to use '$a[1]' but can't find it!

Install it or specify other command in your ~/.timrc file.
Read the file timrc.example for more information."

			ERROR=1 && return 1
		fi
	fi

	if [[ $FILE_ERROR == 1 ]]; then
		if [[ $1 == debug ]]; then
			echo "Can't find the default audio files!" && ERROR=1
		else
			echo "Tim can't find the default audio files!

Put them in ~/.tim or specify other files in your ~/.timrc file.
Read the file timrc.example for more information."

			ERROR=1 && return 1
		fi
	fi

	for x in $CMD_SETTINGS; do
		b=(${(zP)x}) # Put value of the current variable in array.

		if ! $(type -p $b[1] > /dev/null); then # Exists command?
			echo "$x: Command '$b[1]' doesn't exist!" && ERROR=1
		fi
	done

	for x in $RPT_SETTINGS; do
		if [[ ! ${(P)x} == <-> ]] || [[ ${(P)x} != [0-1] ]]; then # Check if it's only integer
			echo "$x: Setting '${(P)x}' is not valid." && ERROR=1
		fi
	done

	for x in $INT_SETTINGS; do
		if [[ ! ${(P)x} == <-> ]] || [[ ${(P)x} < 1 ]]; then # Check if it's only integer
			echo "$x: Setting '${(P)x}' is not valid." && ERROR=1
		fi
	done

	[[ $1 == debug ]] && [[ $ERROR == 1 ]] && echo
}


###############################################################################
# INFORMATION SECTION                                                         #
###############################################################################
function usage {
	echo "Usage: $FILENAME [OPTION]... [NUMBER]...
Try '--help' for more information."
}

function help {
	echo "Usage: $FILENAME [OPTION]... [NUMBER]...

  [NUMBER]                 Wait [NUMBER] minutes before starting alarm.
  -i, --interval [NUMBER]  Work [NUMBER] minutes and pause [NUMBER] minutes.
                            (Default: 15 minutes work and pause.)
  -p, --pomodoro           Work X minutes and pause X minutes. Run X times.
                            (Default: 25 minutes work, 5 minutes break and
                             stop after 4 times.)
                            <http://en.wikipedia.org/wiki/Pomodoro_Technique>
  -d, --debug              Display value of all variables and exit.
  -h, --help               Display this help and exit.
  -v, --version            Output version information and exit.

Examples:

  $FILENAME 5      # Wait 5 minutes before starting alarm.
  $FILENAME -i 10  # Work for 10 minutes and pause for 10 minutes.
  $FILENAME -i     # Same as above but use the timrc (or default) setting.
  $FILENAME -p     # Pomodoro mode. Using timrc (or default) settings.

Configuration:

  Read the file timrc.example for more information."
}

function version {
	echo "Tim (Timer Script Improved) $VERSION

Web: http://ggustafsson.github.com/Timer-Script-Improved
Git: https://github.com/ggustafsson/Timer-Script-Improved

Written by Göran Gustafsson <gustafsson.g@gmail.com>.
Released under the BSD 2-Clause license."
}


###############################################################################
# TIMER MODE SECTION                                                          #
###############################################################################
function timer {
	validate_settings
	[[ $ERROR == 1 ]] && return 1

	(( MINUTES_IN_SECONDS = $1 * 60 ))

	echo -n "Starting timer. Waiting for $1 "
	if [[ $1 > 1 ]]; then
		echo "minutes."
	else
		echo "minute."
	fi
	echo "Stop with Ctrl+C."

	sleep $MINUTES_IN_SECONDS
	print -P "\n%B%F{red}ALARM SET OFF!%f%b"

	if [[ $TIMER_REPEAT_ALARM == 1 ]]; then
		while true; do
			eval $TIMER_CMD
		done
	else
		eval $TIMER_CMD
	fi
}


###############################################################################
# INTERVAL MODE SECTION                                                       #
###############################################################################
function interval {
	validate_settings
	[[ $ERROR == 1 ]] && return 1

	if [[ -z $1 ]]; then
		MINUTES=$INTERVAL
	else
		MINUTES=$1
	fi
	(( MINUTES_IN_SECONDS = $MINUTES * 60 ))

	CURRENT_MODE=work

	echo -n "Starting timer. Interval of $MINUTES "
	if [[ $MINUTES > 1 ]]; then
		echo "minutes."
	else
		echo "minute."
	fi
	echo "Start working now. Stop with Ctrl+C."

	while true; do
		sleep $MINUTES_IN_SECONDS

		[ -z $LINEBREAK ] && echo && LINEBREAK=0

		if [[ $CURRENT_MODE == work ]]; then
			print -P "%B%F{green}TAKE A LITTLE BREAK!%f%b"
			eval $BREAK_CMD

			CURRENT_MODE=break
		else
			print -P "%B%F{red}START WORKING AGAIN!%f%b"
			eval $WORK_CMD

			CURRENT_MODE=work
		fi
	done
}


###############################################################################
# POMODORO MODE SECTION                                                       #
###############################################################################
function pomodoro {
	validate_settings
	[[ $ERROR == 1 ]] && return 1

	(( POMODORO_WORK_IN_SECONDS  = $POMODORO_WORK  * 60 ))
	(( POMODORO_BREAK_IN_SECONDS = $POMODORO_BREAK * 60 ))

	CURRENT_MODE=work
	CURRENT_RUN=1
	MINUTES_IN_SECONDS=$POMODORO_WORK_IN_SECONDS

	echo "Starting timer. Pomodoro mode:
 Work $POMODORO_WORK min. Break $POMODORO_BREAK min. Stop after $POMODORO_STOP.

Start working now. Stop with Ctrl+C."

	while [[ $CURRENT_RUN < $POMODORO_STOP ]]; do
		sleep $MINUTES_IN_SECONDS

		[ -z $LINEBREAK ] && echo && LINEBREAK=0

		if [[ $CURRENT_MODE == work ]]; then
			print -P "%B%F{green}TAKE A LITTLE BREAK!%f%b"
			eval $BREAK_CMD

			CURRENT_MODE=break
			MINUTES_IN_SECONDS=$POMODORO_BREAK_IN_SECONDS
		else
			print -P "%B%F{red}START WORKING AGAIN!%f%b"
			eval $WORK_CMD

			CURRENT_MODE=work
			MINUTES_IN_SECONDS=$POMODORO_WORK_IN_SECONDS

			(( CURRENT_RUN = $CURRENT_RUN + 1 ))
		fi
	done

	sleep $MINUTES_IN_SECONDS
	echo "\nWorking session is over!"

	if [[ $POMODORO_REPEAT_ALARM == 1 ]]; then
		while true; do
			eval $POMODORO_CMD
		done
	else
		eval $POMODORO_CMD
	fi
}


###############################################################################
# DEBUG SECTION (DISPLAY VARIABLES)                                           #
###############################################################################
function debug {
	echo "DEBUG MODE\n"

	validate_settings debug

	echo "VALUE OF ALL VARIABLES:
 FILENAME: $FILENAME
 DIRECTORY: $DIRECTORY
 VERSION: $VERSION
 DEFAULT_CMD: $DEFAULT_CMD"

	for x in $CMD_SETTINGS; do
		echo " $x: ${(P)x}"
	done

	for x in $RPT_SETTINGS; do
		echo " $x: ${(P)x}"
	done

	for x in $INT_SETTINGS; do
		echo " $x: ${(P)x}"
	done
}


###############################################################################
# OPTIONS AND EXECUTION SECTION                                               #
###############################################################################
case $# in
	0) usage ;;
	1)
		case $1 in
			<->) # Check if $1 is integer.
				if [[ $1 > 0 ]]; then
					timer $1 # Send argument $1 to function timer.
				else
					usage && return 1
				fi
			;;
			-i | --interval) interval ;;
			-p | --pomodoro) pomodoro ;;
			-d | --debug)    debug    ;;
			-h | --help)     help     ;;
			-v | --version)  version  ;;
			*)
				usage && return 1
			;;
		esac
	;;
	2)
		if [[ $1 == -i ]] && [[ $2 == <-> ]]; then # Check if $2 is integer.
			if [[ $2 > 0 ]]; then
				interval $2 # Send argument $2 to function interval.
			else
				usage && return 1
			fi
		else
			usage && return 1
		fi
	;;
	*) usage && return 1 ;;
esac

