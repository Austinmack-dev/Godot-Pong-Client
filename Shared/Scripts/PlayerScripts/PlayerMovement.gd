extends KinematicBody2D

var moveY = 0
var toMove = Vector2()
var player_id

puppet func _move_player(moveVec):
	toMove = moveVec
	

func _ready():
	var lobby = get_node("/root/LobbyNode")
	player_id = lobby.my_id
#	var gameWorldLabel = get_node("/root/GameWorld/GameWorldLabel")
#	gameWorldLabel.text = gameWorldLabel.text + " id of this client: " + str(player_id)

func _physics_process(delta):
	if name.find(str(player_id)) != -1:
		moveY = 0
		if Input.is_key_pressed(KEY_UP) or Input.is_key_pressed(KEY_W):
			moveY = moveY - 1
		if Input.is_key_pressed(KEY_DOWN) or Input.is_key_pressed(KEY_S):
			moveY = moveY + 1
		toMove = Vector2(0,moveY)
		rpc_unreliable_id(1,"_send_server_movement_data", toMove)
		move_and_slide(toMove*200)
	else:
		move_and_slide(toMove*200)	
