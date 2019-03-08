extends KinematicBody2D

var my_id
var moveY = 0
export var movementSpeed = 200

# Called when the node enters the scene tree for the first time.
func _ready():
	var lobby = get_node("/root/LobbyNode")
	my_id = lobby.my_id
	var gameWorldLabel = get_node("/root/GameWorld/GameWorldLabel")
	gameWorldLabel.text = gameWorldLabel.text + " id of this client: " + str(my_id)

func _get_inputs():
	moveY = 0
	if Input.is_key_pressed(KEY_UP) or Input.is_key_pressed(KEY_W):
		moveY = moveY - 1
	if Input.is_key_pressed(KEY_DOWN) or Input.is_key_pressed(KEY_S):
		moveY = moveY + 1

func _physics_process(delta):
	_get_inputs()
	var toMove = Vector2(0,moveY)
	var movementVector = toMove.normalized() * movementSpeed
	var movement = move_and_slide(movementVector)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
