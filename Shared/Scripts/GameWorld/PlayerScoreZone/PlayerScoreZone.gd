extends Area2D

var game
var scoreToSend = 1

func _ready():
	game = get_node("/root/GameWorld")


func _on_ScoreZone_body_entered(body):
	if(body.get_name() == "Ball"):
		var myId = name.substr(10,name.length())
		
		body.hide()
		game.rpc_id(1,"_send_score",int(myId),scoreToSend)
