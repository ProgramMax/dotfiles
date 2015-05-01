# If not running interactively, don't do anything
[[ $- != *i* ]] && return

shopt -s checkwinsize

function make_ps1() {
	# Reset
	local ResetColor="\[\033[0m\]"

	# Regular colors
	local Black="\[\033[0;30m\]"
	local Red="\[\033[0;31m\]"
	local Green="\[\033[0;32m\]"
	local Yellow="\[\033[0;33m\]"
	local Blue="\[\033[0;34m\]"
	local Purple="\[\033[0;35m\]"
	local Cyan="\[\033[0;36m\]"
	local White="\[\033[0;37m\]"

	# Bold
	local BoldBlack="\[\033[1;30m\]"
	local BoldRed="\[\033[1;31m\]"
	local BoldGreen="\[\033[1;32m\]"
	local BoldYellow="\[\033[1;33m\]"
	local BoldBlue="\[\033[1;34m\]"
	local BoldPurple="\[\033[1;35m\]"
	local BoldCyan="\[\033[1;36m\]"
	local BoldWhite="\[\033[1;37m\]"

	# Underline
	local UnderlineBlack="\[\033[4;30m\]"
	local UnderlineRed="\[\033[4;31m\]"
	local UnderlineGreen="\[\033[4;32m\]"
	local UnderlineYellow="\[\033[4;33m\]"
	local UnderlineBlue="\[\033[4;34m\]"
	local UnderlinePurple="\[\033[4;35m\]"
	local UnderlineCyan="\[\033[4;36m\]"
	local UnderlineWhite="\[\033[4;37m\]"

	# Background
	local OnBlack="\[\033[40m\]"
	local OnRed="\[\033[41m\]"
	local OnGreen="\[\033[42m\]"
	local OnYellow="\[\033[43m\]"
	local OnBlue="\[\033[44m\]"
	local OnPurple="\[\033[45m\]"
	local OnCyan="\[\033[46m\]"
	local OnWhite="\[\033[47m\]"

	# High intensity
	local IntenseBlack="\[\033[0;90m\]"
	local IntenseRed="\[\033[0;91m\]"
	local IntenseGreen="\[\033[0;92m\]"
	local IntenseYellow="\[\033[0;93m\]"
	local IntenseBlue="\[\033[0;94m\]"
	local IntensePurple="\[\033[0;95m\]"
	local IntenseCyan="\[\033[0;96m\]"
	local IntenseWhite="\[\033[0;97m\]"

	# Bold high intensity
	local BoldIntenseBlack="\[\033[1;90m\]"
	local BoldIntenseRed="\[\033[1;91m\]"
	local BoldIntenseGreen="\[\033[1;92m\]"
	local BoldIntenseYellow="\[\033[1;93m\]"
	local BoldIntenseBlue="\[\033[1;94m\]"
	local BoldIntensePurple="\[\033[1;95m\]"
	local BoldIntenseCyan="\[\033[1;96m\]"
	local BoldIntenseWhite="\[\033[1;97m\]"

	# High intensity background
	local OnIntenseBlack="\[\033[0;100m\]"
	local OnIntenseRed="\[\033[0;101m\]"
	local OnIntenseGreen="\[\033[0;102m\]"
	local OnIntenseYellow="\[\033[0;103m\]"
	local OnIntenseBlue="\[\033[0;104m\]"
	local OnIntensePurple="\[\033[0;105m\]"
	local OnIntenseCyan="\[\033[0;106m\]"
	local OnIntenseWhite="\[\033[0;107m\]"

	# Variables
	local Time24hhmmss="\t"
	local PathShort="\W"
	local PathFull="\w"
	local NewLine="\n"


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


	PS1="$BoldWhite\342\224\214\342\224\200\$([[ \$? != 0 ]] && echo \"[$Red"

	#PS1=$PS1'$(
	#	ErrorCode=$?
	#	if $ErrorCode &>/dev/null ; then
	#		echo -n "'$BoldRed'$ErrorCode'$ResetColor'"
	#	fi
	#)'
	# PS1=$PS1"\342\234\227✓"
	PS1=$PS1"X$BoldWhite]\342\224\200\")[$(if [[ ${EUID} == 0 ]]; then echo "$Red\u$BoldWhite@$IntenseCyan\h"; else echo "$Yellow\u$BoldWhite@$IntenseCyan\h"; fi)$BoldWhite]\342\224\200[$Green\w$BoldWhite]\n$BoldWhite\342\224\224\342\224\200\342\224\200\076 $ResetColor"

	export PS1
}



#if [[ $'\n'${match_lhs} == *$'\n'"TERM "${safe_term}* ]] ; then
	#PS1="\[\033[0;37m\]\342\224\214\342\224\200\$([[ \$? != 0 ]] && echo \"[\[\033[0;31m\]\342\234\227\[\033[0;37m\]]\342\224\200\")[$(if [[ ${EUID} == 0 ]]; then echo '\[\033[0;31m\]\u\[\033[0;37m\]@\[\033[0;96m\]\h'; else echo '\[\033[0;33m\]\u\[\033[0;37m\]@\[\033[0;96m\]\h'; fi)\[\033[0;37m\]]\342\224\200[\[\033[0;32m\]\w\[\033[0;37m\]]\n\[\033[0;37m\]\342\224\224\342\224\200\342\224\200\076 \[\033[0m\]"
#else
#	PS1="\u@\h \w \$([[ \$? != 0 ]] && echo \":( \")\$ "
#fi

make_ps1

PS2="> "
PS3="> "
PS4="+ "
