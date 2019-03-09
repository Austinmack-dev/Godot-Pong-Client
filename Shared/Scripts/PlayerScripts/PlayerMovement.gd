extends KinematicBody2D

var player_id
var moveY = 0
var movementVector = Vector2()
var toMove
export var movementSpeed = 200
var id_to_move
var serverMove = Vector2()

puppet func _move_player(moveVec, id, info):
	#print("my client id: " + str(player_id) + " server sent id: " + str(id))
	var keys = info.keys()
	
	for i in range(0,keys.size()):
		if(keys[i] != id):
			var player2 = get_node("/root/GameWorld/Player"+str(keys[i]))
			#print("player2 name: " + player2.name + " has node?: " + player2.name + " " + str(has_node("/root/GameWorld/" + player2.name)))
			player2.set_physics_process(false)
#			player2.movementVector = Vector2(0,0)
			#print("player2 movementVector: " + str(player2.movementVector))
		else:
			var player = get_node("/root/GameWorld/Player"+str(id))
			var game = get_node("/root/GameWorld")
			#print("player1 name: " + player.name + " has node?: " + player.name + " "  + str(has_node("/root/GameWorld/" + player.name )))
			
			player.set_physics_process(true)
			player.movementVector = moveVec
			player.serverMove = moveVec
			#print("player1 movementVector: " + str(player.movementVector))
	
	#print("moveVec: " + str(moveVec))	

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


