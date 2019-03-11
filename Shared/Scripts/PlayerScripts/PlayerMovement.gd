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
	if nameIsMe != -1:
		moveY = 0
		if Input.is_key_pressed(KEY_UP) or Input.is_key_pressed(KEY_W):
			moveY = moveY - 1
		if Input.is_key_pressed(KEY_DOWN) or Input.is_key_pressed(KEY_S):
			moveY = moveY + 1
		toMove = Vector2(0,moveY)
		rpc_unreliable_id(1,"_send_server_movement_data", toMove.normalized())
		move_and_slide(toMove.normalized()*moveSpeed)
	else:
		move_and_slide(toMove*moveSpeed)
	
		
