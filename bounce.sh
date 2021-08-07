## Parameters
# how long to wait between each step of moving the window?
WAITTIME=0.001

# how long are the stepe (in pixels)?
STEP=2

# Starting direction
# MOVE==0 up   left
# MOVE==1 down left
# MOVE==2 down right
# MOVE==3 up   right
MOVE=0



## get window id

## OPTIONAL LINE
# the following can be used, so the id of the currently active (focused) window is taken
#WINDOW=$(printf 0x%x $(xdotool getactivewindow) )

# this command however launches xwininfo and the user can select the window by clicking on it
WINDOW=$(xwininfo |grep "Window id"|awk '{print $4}')


## get general starting information
# where are the borders of the screen?
BORDER_H=$(xdpyinfo|grep dimension|awk '{print $2}'|cut -d "x" -f 1)
BORDER_V=$(xdpyinfo|grep dimension|awk '{print $2}'|cut -d "x" -f 2)

# how large is the window?
WIDTH=$(xwininfo -id $WINDOW|grep Width|awk '{print $2}')
HEIGHT=$(xwininfo -id $WINDOW|grep Height|awk '{print $2}')
# and where is the window?
X_PLACE=$(xwininfo -id $WINDOW|grep "Absolute upper-left X"|awk '{print $4}')
Y_PLACE=$(xwininfo -id $WINDOW|grep "Absolute upper-left Y"|awk '{print $4}')


## FUNCTION move
# parses the input of the function by searching for characters, that describe the movement direction
# u: up
# d: down
# l: left
# r: right
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


## FUNCTION update direction
# checks for collisions and updates the movement direction accordingly
updatedirection(){
## use the follwong lines if you constatntly want to update what the size of the window is
# if you resize the window as it is moving these lines will allow for collisions with the new window size
#WIDTH=$(xwininfo -id $WINDOW|grep Width|awk '{print $2}')
#HEIGHT=$(xwininfo -id $WINDOW|grep Height|awk '{print $2}')


## Paddings
# each movement direction has their pair of two paddings
# imagine moving the window up left, you can collide with the top of the screen and/or the left of the screen
# the padding tells you how much space you have left to the top (ONE_PADDING) and the left (TWO_PADDING)
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


## Collision
# in the case that one of the paddings is lower or equal to zero calculate the new direction of movement by adding or substracting from the current movement direction
	if [ $ONE_PADDING -le 0 ] && [ $TWO_PADDING -le 0 ]; then
		MOVE=`expr $MOVE + 2`
	elif [ $ONE_PADDING -le 0 ] && [ $TWO_PADDING -ge 0 ]; then
		MOVE=`expr $MOVE + 1`
	elif [ $ONE_PADDING -ge 0 ] && [ $TWO_PADDING -le 0 ]; then
		MOVE=`expr $MOVE + 3`
	fi 


## Fix direction
# updating the direction like in the section about collisions can lead to directions, that are outside the range from 0 to 3
# we fix the direction by moving it back into the range my means of modulo
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


## Main

## main loop
# each loop we update the direction and then perform the direction
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
