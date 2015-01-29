#!/usr/bin/env bash


_prechauff(){
	clear
	local i
	for (( i=3 ; i>0 ; i-- )); do
		tput setaf 2 ; tput bold ;  tput cup "$MH" "$ML" ; echo "$i"
		sleep 1
	done
	tput cup "$MH" "$ML" ; echo "LETS PLAY THE GAME" ; sleep 2
	tput clear ; tput sgr0
}



_menu(){
	printf "





						 	                      ___          ___          ___          ___     
							                     /__/\        /  /\        /__/\        /__/\    
							                    |  |::\      /  /:/_       \  \:\       \  \:\   
							                    |  |:|:\    /  /:/ /\       \  \:\       \  \:\  
							                  __|__|:|\:\  /  /:/ /:/_  _____\__\:\  ___  \  \:\ 
							                 /__/::::| \:\/__/:/ /:/ /\/__/::::::::\/__/\  \__\:\\
							                 \  \:\~~\__\/\  \:\/:/ /:/\  \:\~~\~~\/\  \:\ /  /:/
							                  \  \:\       \  \::/ /:/  \  \:\  ~~~  \  \:\  /:/ 
							                   \  \:\       \  \:\/:/    \  \:\       \  \:\/:/  
							                    \  \:\       \  \::/      \  \:\       \  \::/   
							                     \__\/        \__\/        \__\/        \__\/    

	"

	tput cup "$MH" "$((ML-5))"
	tput setaf 3
	echo "SPACE INVADERS coded by Notfound"
	tput sgr0
	tput cup $((MH+5)) "$ML" ; echo "1. New game"
	tput cup $((MH+6)) "$ML" ; echo "   q: LEFT"
	tput cup $((MH+7)) "$ML" ; echo "   l: RIGHT"
	tput cup $((MH+8)) "$ML" ; echo "   f: FIRE"
	tput cup $((MH+9)) "$ML" ; echo "   m: MUSIC"
	tput cup $((MH+11)) "$ML" ; echo "2. Quit"

	# Set bold mode
	tput bold ; tput rev
	tput cup $((MH+15)) $ML ; read -p "  Please enter your choice  " choice ; tput sgr0
	case "$choice" in
		1)	_start 		;;
		2)	_exit		;;
		*)	_noob		;;
	esac

	sleep 100
	tput clear
	tput sgr0
	tput rc
}



_draw_area() {
	clear
	local a b c
	tput rev
	for ((a=0;a<=L;a++))
	do
		tput cup 0 "$a" ; echo " "
		tput cup $((H-2)) "$a" ; echo " "
		sleep 0.001
	done
	for ((b=0;b<=H-2;b++)); do
		tput cup "$b" 0 ; echo " "
		tput cup  "$b" $(($(tput cols)-1)); echo " "
		sleep 0.01
	done
	tput sgr0
}

_ennemy(){
	STOP=0
	local ennenmyx=$(($(tput cols)/3)) ennemyy=25
	local r=1 l=0

	ALIEN1='    --o--    '
	ALIEN2='    --v--    '
	ALIEN3='    --o--    '
	ALIEN4='    --v--    '
	ALIEN5='    --o--    '
	ALIEN6='    --v--    '
	BLANC='                                                                                            '
	for ennemyy in $(seq 20 2 $(($(tput lines)-3))); do
		if [ "$r" -eq "1" ]; then
			for ennemyx in {40..60}; do
				alien1x=$ennemyx
				alien2x=$((ennemyx+10))
				alien3x=$((ennemyx+20))
				alien4x=$((ennemyx+30))
				alien5x=$((ennemyx+40))
				alien6x=$((ennemyx+50))

				echo -en "\e[$((ennemyy-2));${alien1x}f $BLANC "
				echo -en "\e[$ennemyy;${alien1x}f         "
				echo -en "\e[$ennemyy;${alien1x}f         "
				echo -en "\e[$ennemyy;${alien2x}f $ALIEN1 "
				echo -en "\e[$ennemyy;${alien3x}f $ALIEN2 "
				echo -en "\e[$ennemyy;${alien4x}f $ALIEN3 "
				echo -en "\e[$ennemyy;${alien5x}f $ALIEN4 "
				echo -en "\e[$ennemyy;${alien6x}f $ALIEN5 "
				sleep 0.5
			done
			r=0 ; l=1
		elif [ "$l" -eq "1" ]; then
			for ennemyx in {60..40}; do
				alien1x=$ennemyx
				alien2x=$((ennemyx+10))
				alien3x=$((ennemyx+20))
				alien4x=$((ennemyx+30))
				alien5x=$((ennemyx+40))
				alien6x=$((ennemyx+50))
				echo -en "\e[$((ennemyy-2));${alien1x}f $BLANC "
				echo -en "\e[$ennemyy;${alien1x}f $ALIEN0 "
				echo -en "\e[$ennemyy;${alien2x}f $ALIEN1 "
				echo -en "\e[$ennemyy;${alien3x}f $ALIEN2 "
				echo -en "\e[$ennemyy;${alien4x}f $ALIEN3 "
				echo -en "\e[$ennemyy;${alien5x}f $ALIEN4 "
				echo -en "\e[$ennemyy;${alien6x}f $ALIEN5 "
				sleep 0.5
			done
			r=1 ; l=0
		fi
	done
	_game_over
}

_beam(){
	local x y
	y=$((ML/2))
	x=$H
	if [ -z $1 ]; then
		soclex=$x 	; socley=$((y+10))
		canonx=$((x+5)); canony=$((y+9))
	fi

	if [ "$1" == "left" ]; then
		: $((canonx--))
		: $((soclex--))
	elif [ "$1" == "right" ]; then
		: $((canonx++))
		: $((soclex++))
	fi
	tput cup $canony $canonx			; echo " █  "
	tput cup $socley $soclex			; echo "   ███████ "
	tput cup $((socley+1)) $soclex	; echo " ███████████ "
}


_fire(){
	nbb="$1"
	firex=$((canonx+1))
	firey=$canony
	#if [ "$nbb" -lt "2" ]; then
		for ((bullety=$((canony-1)) ; bullety>5 ; bullety--)); do
			if [[ "$bullety" -eq "$2" || "$bullety" -eq "$3" || "$bullety" -eq "$4" ||"$bullety" -eq "$5" || "$bullety" -eq "$6" || "$bullety" -eq "$7" ]]; then
				_pwned
				break
			fi
			printf "\e[$bullety;${firex}f I";
			printf "\e[$((bullety+1));${firex}f  ";
			sleep 0.05
		done
		: $((nbb--))
	#fi
}

_pwn(){
	echo ""
}

_draw_highscore(){
	tput cup 2 $ML ; echo "Highscore : $HIGHSCORE"
}


_draw_score(){
	tput cup 2 3 ; echo "Score : $SCORE"
}

_draw_music(){
	tput cup 2 30 ; echo "Music : $1 "
}

_start(){
	_draw_area
	_draw_highscore
	_draw_score
	_draw_music OFF
	_ennemy &
	_beam

	while true; do
		read -s -r -n1 KEY
		_move "$KEY"
	done
}

_move(){
	case "$1" in
                q)      if [[ "$MAXLEFT" -ne "$LEFT" ]]; then
							: $((LEFT--))
							: $((RIGHT--))
							_beam left
                        fi ;;
                l)      if [[ "$MAXRIGHT" -ne "$RIGHT" ]]; then
                                	: $((LEFT++))
							: $((RIGHT++))
							_beam right
                        fi ;;
			f)		( _fire "$nb_bullet" "alien1x" "alien2x" "alien3x" "alien4x" "alien5x" "alien6x" )&
					: $((nb_bullet++))
					;;
			m)		if [ "$music" == "OFF" ]; then
						mplayer music.mp3  </dev/null >/dev/null 2>&1 &
						music="ON"
						_draw_music ON
					else
						ps aux|awk '/mplayer/{print $2}'|xargs kill > /dev/null
						music="OFF"
						_draw_music OFF
					fi
					;;
	esac

}

_touch(){
	: $((nb_bullet--))
}

_noob(){
	tput setaf 2 ; tput bold ; clear
	tput cup $MH $((ML-11)) ; echo "[!] NOOB SPOTTED [!]"
	tput cup $((MH+2)) $((ML-35)) ; echo "Srsly, there is 2 options, that's so difficult to choose a good one ?" ; sleep 5
	_exit
}


_leaveClean(){
	clear ; sleep 1 ; stty echo ; setterm -cursor on
	ps aux|awk '/mplayer/{print $2}'|xargs kill
	ps aux|awk '/\.\/space/{print $2}'|head -n2 |xargs kill
	sleep 2
	STOP=1
	exit 1
}

_game_over(){
	clear ; tput cup $MH $ML ; echo "GAME OVER"
	for osef in "30 50 80"; do
		tput cup $MH $osef ; echo "
	                      ▀▄   ▄▀              
	                     ▄█▀███▀█▄             
	                    █▀███████▀█            
        	            ▀ ▀▄▄ ▄▄▀ ▀            
		"
	done
}

_exit(){
	clear ; sleep 1 ; setterm -cursor on
	exit 0
}

####################################################
########## PAS DE MAIN, PAS DE CHOCOLAINT ##########
####################################################
source spacerc
# SOME VARIABLES
music="OFF"
nb_bullet=0
SCORE=0
H=$(tput lines)
L=$(tput cols)
ML=$((L/2))
MH=$((`tput lines`/2))
#H=$((`tput lines`/2))
MAXLEFT=1
MAXRIGHT=$(($(tput cols)/2))
#LEFT=$(($(tput lines)/2))
LEFT=$MH
RIGHT=$LEFT


# CLEAR THAT FUCKING SCREEN
clear

# HOUSTON, PLZ LAUNCH SOME FUNCTIONS
trap _leaveClean SIGINT
setterm -cursor off      # CURSOR IS FOR T4PZ WHO LOST THE GAME
stty -echo
_prechauff
_menu
