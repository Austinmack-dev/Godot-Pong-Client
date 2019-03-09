extends KinematicBody2D

var player_id
var moveY = 0
var movementVector = Vector2()
var toMove
export var movementSpeed = 200
var id_to_move
var serverMove = Vector2()

puppet func _move_player(moveVec, id, info):
	var keys = info.keys()
	var player2
	var player1
	for i in range(0,keys.size()):
		if(keys[i] != id):
			player2 = get_node("/root/GameWorld/Player"+str(keys[i]))
		else:
			player1 = get_node("/root/GameWorld/Player"+str(id))

	player2.set_physics_process(false)	
	player1.set_physics_process(true)
	player1.movementVector = moveVec
	player1.serverMove = moveVec
	

func _ready():
	var lobby = get_node("/root/LobbyNode")
	player_id = lobby.my_id
	var gameWorldLabel = get_node("/root/GameWorld/GameWorldLabel")
	gameWorldLabel.text = gameWorldLabel.text + " id of this client: " + str(player_id)

func _get_inputs():
	moveY = 0
	if Input.is_key_pressed(KEY_UP) or Input.is_key_pressed(KEY_W):
		moveY = moveY - 1
	if Input.is_key_pressed(KEY_DOWN) or Input.is_key_pressed(KEY_S):
		moveY = moveY + 1
	toMove = Vector2(0,moveY)

func _physics_process(delta):
	if serverMove.y != 0:
		toMove = serverMove
		serverMove = Vector2()
	else:
		_get_inputs()
	
	#movementVector = toMove.normalized()*movementSpeed
	if(moveY != 0):
		rpc_unreliable_id(1,"_send_server_movement_data",toMove, player_id)
		move_and_slide(movementVector*movementSpeed)
	else:
		move_and_slide(toMove*movementSpeed)


