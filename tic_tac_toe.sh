#!/bin/bash

is_end=false
dead_heat=true
X=x
O=o
winner=None
turn=None
board=()
EMPTY=" "
WIN_POS=(0 1 2 3 4 5 6 7 8 0 3 6 1 4 7 2 5 8 0 4 8 2 4 6)

init_variables () {
	for i in {0..8}
	do
		board[i]=$EMPTY
	done
	
	local rnd=$(($RANDOM % 2))
	if [[ $rnd -eq 0 ]]
	then
		turn=$X
	else
		turn=$O
	fi
}

switch_turn () {
	if [[ "$turn" == "$X" ]]
	then
		turn=$O
	else
		turn=$X
	fi
}

draw () {
	clear
	echo "${board[0]}|${board[1]}|${board[2]}"
	echo "-+-+-"
	echo "${board[3]}|${board[4]}|${board[5]}"
	echo "-+-+-"
	echo "${board[6]}|${board[7]}|${board[8]}"
}

input () {
	while true
	do
		read -p "$turn write pos[0-8]: " pos 
		if [[ $pos -ge 0 && $pos -lt 9 && "${board[$pos]}" == "$EMPTY" ]]
		then
			board[$pos]=$turn
			break
		else
			echo Wrong pos!
		fi
	done
}

check_win () {
	for ((i=0; i<"${#WIN_POS[@]}"; i++))
	do
		if [[ "${board[${WIN_POS[i]}]}" == "$turn" && "${board[${WIN_POS[((i+1))]}]}" == "$turn" && "${board[${WIN_POS[((i+2))]}]}" == "$turn" ]]
		then
			winner=$turn
			is_end=true
			break
		else
			((i=i+2))
		fi	
	done

	for ((i=0; i<"${#board[@]}"; i++))
	do
		if [[ "${board[i]}" == "${EMPTY}" ]]
		then
			dead_heat=false
			break
		fi
	done

	if [[ "$dead_heat" == "true" ]]
	then
		is_end=true
	else
		dead_heat=true
	fi
}

init_variables

while ! $is_end
do
	draw
	input
	check_win
	switch_turn
done

draw
echo $winner win!!!
