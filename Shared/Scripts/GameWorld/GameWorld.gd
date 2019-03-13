extends Node2D





puppet func _player_scored(client_id, score):
	print("IN PLAYER SCORED RPC")
	var pScore = get_node("Score-" + str(client_id))
	var textWithoutScore = pScore.text.substr(0,pScore.text.length()-1)
	print(textWithoutScore)
	pScore.text = textWithoutScore + str(score)

func reset_ball():
	var ball = get_node("Ball")
	ball.position = Vector2(0,0)
	ball.show()
