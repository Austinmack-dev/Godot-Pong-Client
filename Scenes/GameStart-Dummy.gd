extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	print("I am in button's ready")
	#Networking.connect("bad_client",self,"_bad_client")
	print("after connect")
	pass # Replace with function body.

func _bad_client():
	print("I am in bad_client signal")
	Networking.extra = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
