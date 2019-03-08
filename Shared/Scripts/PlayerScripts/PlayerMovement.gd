extends KinematicBody2D

var player_id
var moveY = 0
var movementVector
var toMove
export var movementSpeed = 200
var id_to_move

remotesync func _move_player(moveVec, id, info):
	var keys = info.keys()
	print("player id: " + str(player_id))
	if(id == player_id):
		get_node("/root/GameWorld/Player" + str(id)).set_physics_process(true)
	else:
		get_node("/root/GameWorld/Player"+ str(id)).set_physics_process(false)
	#else:
		#movementVector = Vector2(0,0)
		#get_node("/root/GameWorld/Player"+ str(id)).set_physics_process(false)
#	for i in range(0,keys.size()):
#		if(keys[i] == id):
#			movementVector = moveVec
#			get_node("/root/GameWorld/Player"+ str(keys[i])).set_physics_process(true)
#			#_set_physics_process(true)
#		else:
#			movementVector = Vector2(0,0)
#			get_node("/root/GameWorld/Player"+str(keys[i])).set_physics_process(false)
#			#movementVector = Vector2(0,0)
#			#set_physics_process(false)
#
		
		

# Called when the node enters the scene tree for the first time.
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
	movementVector = toMove.normalized()*movementSpeed
	if(toMove.y > 0):
		rpc_id(1,"_send_server_movement_data",movementVector, player_id)
	

func _physics_process(delta):
	_get_inputs()
	
	#var toMove = Vector2(0,moveY)
	#var movementVector = toMove.normalized() * movementSpeed
	var movement = move_and_slide(movementVector)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
