#WINDOW=$(printf 0x%x $(xdotool getactivewindow) )
WINDOW=$(xwininfo |grep "Window id"|awk '{print $4}')

BORDER_H=$(xdpyinfo|grep dimension|awk '{print $2}'|cut -d "x" -f 1)
BORDER_V=$(xdpyinfo|grep dimension|awk '{print $2}'|cut -d "x" -f 2)

WIDTH=$(xwininfo -id $WINDOW|grep Width|awk '{print $2}')
HEIGHT=$(xwininfo -id $WINDOW|grep Height|awk '{print $2}')
X_PLACE=$(xwininfo -id $WINDOW|grep "Absolute upper-left X"|awk '{print $4}')
Y_PLACE=$(xwininfo -id $WINDOW|grep "Absolute upper-left Y"|awk '{print $4}')

WAITTIME=0.001
STEP=2

moveup(){
	Y_PLACE=`expr $Y_PLACE - $STEP`
	xdotool windowmove $WINDOW $X_PLACE $Y_PLACE
}
movedown(){
	Y_PLACE=`expr $Y_PLACE + $STEP`
	xdotool windowmove $WINDOW $X_PLACE $Y_PLACE
}
moveupleft(){
	Y_PLACE=`expr $Y_PLACE - $STEP`
	X_PLACE=`expr $X_PLACE - $STEP`
	xdotool windowmove $WINDOW $X_PLACE $Y_PLACE
}
move(){
	if [[ $1 == *u* ]]; then
		Y_PLACE=`expr $Y_PLACE - $STEP`
	elif [[ $1 == *d* ]]; then
		Y_PLACE=`expr $Y_PLACE + $STEP`
	fi
	if [[ $1 == *l* ]]; then
		X_PLACE=`expr $X_PLACE - $STEP`
	elif [[ $1 == *r* ]]; then
		X_PLACE=`expr $X_PLACE + $STEP`
	fi
	xdotool windowmove $WINDOW $X_PLACE $Y_PLACE
	sleep $WAITTIME
}
updatedirection(){
#WIDTH=$(xwininfo -id $WINDOW|grep Width|awk '{print $2}')
#HEIGHT=$(xwininfo -id $WINDOW|grep Height|awk '{print $2}')
	if [ $MOVE == 0 ]; then
		ONE_PADDING=$Y_PLACE
		TWO_PADDING=$X_PLACE
	elif [ $MOVE == 1 ]; then
		ONE_PADDING=$X_PLACE
		TWO_PADDING=`expr $BORDER_V - $Y_PLACE - $HEIGHT`
	elif [ $MOVE == 2 ]; then
		ONE_PADDING=`expr $BORDER_V - $Y_PLACE - $HEIGHT`
		TWO_PADDING=`expr $BORDER_H - $X_PLACE - $WIDTH`
	elif [ $MOVE == 3 ]; then
		ONE_PADDING=`expr $BORDER_H - $X_PLACE - $WIDTH`
		TWO_PADDING=$Y_PLACE
	fi

	if [ $ONE_PADDING -le 0 ] && [ $TWO_PADDING -le 0 ]; then
		MOVE=`expr $MOVE + 2`
	elif [ $ONE_PADDING -le 0 ] && [ $TWO_PADDING -ge 0 ]; then
		MOVE=`expr $MOVE + 1`
	elif [ $ONE_PADDING -ge 0 ] && [ $TWO_PADDING -le 0 ]; then
		MOVE=`expr $MOVE + 3`
	fi 

	if [ $MOVE == -1 ]; then
		MOVE=3
	elif [ $MOVE == -2 ]; then
		MOVE=2
	elif [ $MOVE == -3 ]; then
		MOVE=1
	elif [ $MOVE == 4 ]; then
		MOVE=0
	elif [ $MOVE == 5 ]; then
		MOVE=1
	elif [ $MOVE == 6 ]; then
		MOVE=2
	fi
}

MOVE=3
while true
do
	updatedirection
	if [ $MOVE == 0 ]; then
		move ul
	elif [ $MOVE == 1 ]; then
		move dl
	elif [ $MOVE == 2 ]; then
		move dr
	elif [ $MOVE == 3 ]; then
		move ur
	fi
done


#MOVE=0
#while true
#do
#	if [ $MOVE == 0 ]; then
#		if [ $Y_PLACE -ge 0 ] && [ $X_PLACE -ge 0 ]; then
#			move ul
#		else
#			MOVE=1
#		fi
#	elif [ $MOVE == 1 ]; then
#		BOTTOM=`expr $Y_PLACE + $HEIGHT`
#		if [ $BOTTOM -le 1080 ]; then
#			move dl
#		else
#			MOVE=0
#		fi
#	elif [ $MOVE ==2 ]; then
#	ls
#		
#	fi
#done
