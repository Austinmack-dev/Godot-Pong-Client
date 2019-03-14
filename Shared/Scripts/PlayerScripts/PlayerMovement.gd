extends KinematicBody2D

var moveY = 0
var toMove = Vector2()
var player_id
var nameIsMe
const moveSpeed = 250

puppet func _move_player(moveVec):
	toMove = moveVec

func _ready():
	var lobby = get_node("/root/LobbyNode")
	player_id = lobby.my_id
	nameIsMe = name.find(str(player_id))


func _physics_process(delta):
	#if the client in focus is the same as my network id
	#get the inputs from the keyboard, and move based on those inputs
	if nameIsMe != -1:
		#resets the moveY variable to not constantly move
		moveY = 0
		#if the user presses up or W, then move up
		if Input.is_key_pressed(KEY_UP) or Input.is_key_pressed(KEY_W):
			moveY = moveY - 1
		#if the user presses down or S, move down
		if Input.is_key_pressed(KEY_DOWN) or Input.is_key_pressed(KEY_S):
			moveY = moveY + 1
			
		#set the move Vector2 to move in the y direction only, since our paddles
		#are on the left and right of the game world screen
		toMove = Vector2(0,moveY)
		#send the movement data from our controlled player to the server
		rpc_unreliable_id(1,"_send_server_movement_data", toMove.normalized())
		#move based on the calculated move vector
		move_and_slide(toMove.normalized()*moveSpeed)
	#if we are the remote client, move based on the response from the server
	else:
		move_and_slide(toMove*moveSpeed)
	
		
