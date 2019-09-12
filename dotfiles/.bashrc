# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export PATH=$PATH:/usr/lib/emscripten
export EDITOR=vim

shopt -s checkwinsize



# Formatting
ResetColor="\e[0m"
Bold="\e[1m"
Dim="\e[2m"
Italic="\e[3m"
Underline="\e[4m"
Blink="\e[5m"
InvertColors="\e[7m"
Hidden="\e[8m"
Strikethrough="\e[9m"

# Regular colors
Black="\e[30m"
Red="\e[31m"
Green="\e[32m"
Yellow="\e[33m"
Blue="\e[34m"
Purple="\e[35m"
Cyan="\e[36m"
White="\e[37m"

# Background
OnBlack="\e[40m"
OnRed="\e[41m"
OnGreen="\e[42m"
OnYellow="\e[43m"
OnBlue="\e[44me"
OnPurple="\e[45m"
OnCyan="\e[46m"
OnWhite="\e[47me"

# High intensity
IntenseBlack="\e[90m"
IntenseRed="\e[91m"
IntenseGreen="\e[92m"
IntenseYellow="\e[93m"
IntenseBlue="\e[94m"
IntensePurple="\e[95m"
IntenseCyan="\e[96m"
IntenseWhite="\e[97m"

# High intensity background
OnIntenseBlack="\e[100m"
OnIntenseRed="\e[101m"
OnIntenseGreen="\e[102m"
OnIntenseYellow="\e[103m"
OnIntenseBlue="\e[104m"
OnIntensePurple="\e[105m"
OnIntenseCyan="\e[106m"
OnIntenseWhite="\e[107m"

# Variables
Time24hhmmss="\t"
PathShort="\W"
PathFull="\w"
NewLine="\n"
Username="\u"
MachineName="\h"

# Actions
Alert="\a"

function make_ps1() {
	local ErrorCode=$?




	# First line
	PS1="$Bold$White┌─"

	# If there is an error code, print it in a box
	if [ $ErrorCode != 0 ] ; then
		PS1=$PS1"[$Red$ErrorCode$Bold$White]─"
	fi

	# Print the username and system name
	PS1=$PS1"["
	# If we are root, show the username as red
	if [ "$(whoami)" == 'root' ]; then
		PS1=$PS1"$Red"
	else
		PS1=$PS1"$Yellow"
	fi
	PS1=$PS1$Username$Bold$White@$IntenseCyan$MachineName$Bold$White"]─"

	# Print the working directory, highlighting the git root
	PS1=$PS1"[$Green"
	local Path=$PWD
	if [ "${Path#$HOME}" != "$Path" ] ; then
		Path="~${Path#$HOME}"
	fi

	if git branch &>/dev/null ; then
		local GitRoot=$(git rev-parse --show-toplevel)
		if [ "${GitRoot#$HOME}" != "$GitRoot" ] ; then
			GitRoot="~${GitRoot#$HOME}"
		fi
		PS1=$PS1$(dirname $GitRoot)"/"
		PS1=$PS1$Purple$(basename $GitRoot)
		PS1=$PS1$Green${Path#$GitRoot}
	else
		PS1=$PS1$Green$Path
	fi
	PS1=$PS1$Bold$White"]"

	# Print the git branch if it exists
	if git branch &>/dev/null ; then
		PS1=$PS1"─["
		if git status --porcelain | grep -q "\\S" ; then
			# There are changes to working tree
			PS1=$PS1$Purple
		else
			# There is nothing to commit
			PS1=$PS1$Green
		fi
		PS1=$PS1$(git branch 2>/dev/null | grep '*' | sed 's/* \(.*\)/\1/')$Bold$White"]"
	fi
	PS1=$PS1"\n"




	# Second line
	PS1=$PS1"$Bold$White└──> $ResetColor"

	export PS1
}

function make_ps2() {
	PS2="$Bold$White└──> $ResetColor"
	export PS2
}

function make_ps3() {
	PS3="$Bold$White> $ResetColor"
	export PS3
}

function make_ps4() {
	PS4="$Bold$White+ $ResetColor"
	export PS4
}

function make_prompts() {
	make_ps1
	make_ps2
	make_ps3
	make_ps4
}


function set_file_system_node_colors() {
	# directory
	LS_COLORS=$LS_COLORS'di=0;35:'

	# file
	LS_COLORS=$LS_COLORS'fi=0;0:'

	# symbolic link
	LS_COLORS=$LS_COLORS'ln=0;32:'

	# symbolic link pointing to a non-existent file (orphan)
	LS_COLORS=$LS_COLORS'or=01;32:'

	# executable
	LS_COLORS=$LS_COLORS'ex=0;1:'

	export LS_COLORS
}

function do_stuff() {
	make_prompts
	set_file_system_node_colors
}

PROMPT_COMMAND=do_stuff

alias ls='ls --color -F'
