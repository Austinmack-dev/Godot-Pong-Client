extends Node2D

var p1Score = 0
var p2Score = 0

puppet func _player_scored(client_id, isPlayer1, player_score,info):
#	var isP1 = false
	var keys = info.keys()
	var pScore = get_node("Score-" + str(client_id))
	var textWithoutScore = pScore.text.substr(0,pScore.text.length()-1)
#	if(keys[0] == client_id):
#		isP1 = true
#	if(keys[1] == client_id):
#		isP1 = false
	if(isPlayer1 == true):
		p1Score += player_score
		pScore.text = textWithoutScore + str(p1Score)
	else:
		p2Score += player_score
		pScore.text = textWithoutScore + str(p2Score)