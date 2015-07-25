# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export PATH=$PATH:/usr/lib/emscripten
export EDITOR=vim

shopt -s checkwinsize


# Reset
ResetColor="\[\033[0m\]"

# Regular colors
Black="\[\033[0;30m\]"
Red="\[\033[0;31m\]"
Green="\[\033[0;32m\]"
Yellow="\[\033[0;33m\]"
Blue="\[\033[0;34m\]"
Purple="\[\033[0;35m\]"
Cyan="\[\033[0;36m\]"
White="\[\033[0;37m\]"

# Bold
BoldBlack="\[\033[1;30m\]"
BoldRed="\[\033[1;31m\]"
BoldGreen="\[\033[1;32m\]"
BoldYellow="\[\033[1;33m\]"
BoldBlue="\[\033[1;34m\]"
BoldPurple="\[\033[1;35m\]"
BoldCyan="\[\033[1;36m\]"
BoldWhite="\[\033[1;37m\]"

# Underline
UnderlineBlack="\[\033[4;30m\]"
UnderlineRed="\[\033[4;31m\]"
UnderlineGreen="\[\033[4;32m\]"
UnderlineYellow="\[\033[4;33m\]"
UnderlineBlue="\[\033[4;34m\]"
UnderlinePurple="\[\033[4;35m\]"
UnderlineCyan="\[\033[4;36m\]"
UnderlineWhite="\[\033[4;37m\]"

# Background
OnBlack="\[\033[40m\]"
OnRed="\[\033[41m\]"
OnGreen="\[\033[42m\]"
OnYellow="\[\033[43m\]"
OnBlue="\[\033[44m\]"
OnPurple="\[\033[45m\]"
OnCyan="\[\033[46m\]"
OnWhite="\[\033[47m\]"

# High intensity
IntenseBlack="\[\033[0;90m\]"
IntenseRed="\[\033[0;91m\]"
IntenseGreen="\[\033[0;92m\]"
IntenseYellow="\[\033[0;93m\]"
IntenseBlue="\[\033[0;94m\]"
IntensePurple="\[\033[0;95m\]"
IntenseCyan="\[\033[0;96m\]"
IntenseWhite="\[\033[0;97m\]"

# Bold high intensity
BoldIntenseBlack="\[\033[1;90m\]"
BoldIntenseRed="\[\033[1;91m\]"
BoldIntenseGreen="\[\033[1;92m\]"
BoldIntenseYellow="\[\033[1;93m\]"
BoldIntenseBlue="\[\033[1;94m\]"
BoldIntensePurple="\[\033[1;95m\]"
BoldIntenseCyan="\[\033[1;96m\]"
BoldIntenseWhite="\[\033[1;97m\]"

# High intensity background
OnIntenseBlack="\[\033[0;100m\]"
OnIntenseRed="\[\033[0;101m\]"
OnIntenseGreen="\[\033[0;102m\]"
OnIntenseYellow="\[\033[0;103m\]"
OnIntenseBlue="\[\033[0;104m\]"
OnIntensePurple="\[\033[0;105m\]"
OnIntenseCyan="\[\033[0;106m\]"
OnIntenseWhite="\[\033[0;107m\]"

# Variables
Time24hhmmss="\t"
PathShort="\W"
PathFull="\w"
NewLine="\n"
Username="\u"
MachineName="\h"

function make_ps1() {
	local ErrorCode=$?




	# First line
	PS1="$BoldWhite┌─"

	# If there is an error code, print it in a box
	if [ $ErrorCode != 0 ] ; then
		PS1=$PS1"[$Red$ErrorCode$BoldWhite]─"
	fi

	# Print the username and system name
	PS1=$PS1"["
	# If we are root, show the username as red
	if [ "$(whoami)" == 'root' ]; then
		PS1=$PS1"$Red"
	else
		PS1=$PS1"$Yellow"
	fi
	PS1=$PS1$Username$BoldWhite@$IntenseCyan$MachineName$BoldWhite"]─"

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
	PS1=$PS1$BoldWhite"]"

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
		PS1=$PS1$(git branch 2>/dev/null | grep '*' | sed 's/* \(.*\)/\1/')$BoldWhite"]"
	fi
	PS1=$PS1"\n"




	# Second line
	PS1=$PS1"$BoldWhite└──> $ResetColor"

	export PS1
}

function make_ps2() {
	PS2="$BoldWhite└──> $ResetColor"
	export PS2
}

function make_ps3() {
	PS3="$BoldWhite> $ResetColor"
	export PS3
}

function make_ps4() {
	PS4="$BoldWhite+ $ResetColor"
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
