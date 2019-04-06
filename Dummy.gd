extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	var idLabel =  get_node("idLabel")
	idLabel.text = str(get_tree().multiplayer.get_network_unique_id())
