# If not running interactively, don't do anything
[[ $- != *i* ]] && return

shopt -s checkwinsize

ErrorCode=$?

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

function make_ps1() {
	# Print previous error code in red
	PS1='$(es=$? ; case $es in 0|130) ;; *) echo "'$BoldRed'$es|'$ResetColor'" ;; esac)'
	# Print current time in yellow
	PS1=$PS1"$BoldYellow$Time24hhmmss "
	# Print user@host in green if direct connection, cyan otherwise
	PS1=$PS1'$(
		if [ -n "$SSH_CLIENT" ] ; then
			echo "'$BoldCyan'"
		else
			echo "'$BoldGreen'"
		fi)'"\u@\h$ResetColor"
	# Print path in blue, highlighting git root
	PS1=$PS1":"'$(
		path="\w"
		
		if git branch &>/dev/null ; then
			git_root=$(git rev-parse --show-toplevel)
			if [ ${git_root#HOME} != ${git_root} ] ; then
				git_root=\~${git_root#HOME}
			fi
			echo -n "'$BoldBlue'$(dirname $git_root)/"
			echo -n "'$BoldPurple'$(basename $git_root)"
			echo -n "'$BoldBlue'${path#$git_root}"
		else
			echo -n "'$BoldBlue'$path"
		fi
	)'"$ResetColor"
	# Print current git branch if it exists
	#PS1=$PS1'$(
	#	if git branch &>/dev/null ; then
	#		echo -n " '$IntenseBlack'(" ;
	#		if git status --porcelain | grep -q "\\S" ; then
	#			# Changes to working tree
	#			INDEX=$(git status --porcelain | cut -c1 | grep -v "[?U]" | grep "\\S" | sort | uniq --count | tr AMD +~- | sed '\''s/\\s*\([0-9]\+\) \(.\)\\s*/\2\1/'\'' | xargs)
	#			WORKING=$(git status --porcelain | cut -c2 | grep "\\S" | sort | uniq --count | tr "AMD?U" "+~\\-?!" | sed '\''S/\\s*\([0-9]\+\) \(.\)\\s*/\2\1/'\'' | xargs)
	#			echo -n "'$IntenseRed'$(__git_ps1 "%s") "
	#			echo -n "'$Green'$INDEX"
	#			[ -n "$INDEX" -a -n "$WORKING" ] && echo -n "'$IntenseBlack' | "
	#			echo -n "'$Red'$WORKING";
	#		else
	#			# Clean repository - nothing to commit
	#			echo -n "'$Green'$(__git_ps1 "%s")"
	#		fi;
	#		echo -n "'$IntenseBlack')'$ResetColor'";
	#	fi)'
	PS1=$PS1$NewLine'\$ '





	# First line
	PS1="$BoldWhite┌─"

	# If there is an error code, print it in a box
	# local ErrorCode=$?
	if [ $ErrorCode != 0 ] ; then
		PS1=$PS1"[$Red$ErrorCode$BoldWhite]─"
	fi

	PS1=$PS1"["

	# If we are root, show the username as red
	if [ "$(whoami)" == 'root' ]; then
		PS1=$PS1"$Red"
	else
		PS1=$PS1"$Yellow"
	fi
	PS1=$PS1"\u$BoldWhite@$IntenseCyan\h$BoldWhite]─[$Green\w$BoldWhite]\n"

	# Second line
	PS1=$PS1"$BoldWhite└──> $ResetColor"

	export PS1
}

function make_ps2() {
	PS2="$BoldWhite└─> $ResetColor"
	export PS2
}

function make_ps3() {
	PS3="$BoldWhite$> $ResetColor"
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

PROMPT_COMMAND=make_prompts
