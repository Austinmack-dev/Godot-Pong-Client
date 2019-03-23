extends Node2D

var timer = Timer
var timeLabel
var gameStartLabel
var nextPointLabel
const EndGameScene = preload("res://Shared/Scenes/EndGame/EndGame.tscn")
var ball

func _ready():
	gameStartLabel = get_node("GameStartLabel")
	nextPointLabel = get_node("NextPointLabel")
	timeLabel = get_node("TimerLabel")

func reset_player_score_labels():
	for child in get_children():
		if(child.name.find("Score-") != -1):
			child.text = str(0)

puppet func _player_scored(client_id, score):
	var pScore = get_node("Score-" + str(client_id))
	pScore.text = str(score)

puppet func _end_game(player_name,playerPosNames):
	for i in range(0,playerPosNames.size()):
		var player = get_node(playerPosNames[i].playerName)
		player.position = playerPosNames[i].pos
#	print("ball move direction on client--before set: " + str(ball.moveDir))
#	ball.position = ball_pos_moveDir[0]
#	ball.moveDir = ball_pos_moveDir[1]
#	print("ball_pos_moveDir from server: " + str(ball_pos_moveDir[1]))
#	print("ball move direction on client--after set: " + str(ball.moveDir))
	reset_player_score_labels()
	set_ball_and_player_physics(false)
	
	
	
	#hide the game world
	hide()
	
	#show the end game screen
	if(has_node("/root/EndGame")):
		var end = get_node("/root/EndGame")
		end.show()
		var playerWinLabel = end.get_node("PlayerWinLabel")
		playerWinLabel.text = player_name + " wins the game!!!"
	else:
		var end = EndGameScene.instance()
		get_tree().get_root().add_child(end)
		var playerWinLabel = end.get_node("PlayerWinLabel")
		playerWinLabel.text = player_name + " wins the game!!!"

puppet func _reset_ball_on_client(ball_pos):
	#show the label
	timeLabel.show()
	nextPointLabel.show()
	gameStartLabel.hide()
	#reset the ball to the center
	set_ball_and_player_physics(false)
	ball.position = ball_pos
	#show the ball and stop it from moving, and start the timer
	ball.show()
	#set_physics_process(true)

puppet func _send_client_time_left(timeLeft):
	timeLabel.text = str(timeLeft)
	
puppet func _timer_timed_out_on_server():
	set_ball_and_player_physics(true)
	gameStartLabel.hide()
	nextPointLabel.hide()	
	timeLabel.hide()

func set_ball_and_player_physics(ballAndPlayerPhysics):
	ball = get_node("Ball")
	ball.set_physics_process(ballAndPlayerPhysics)
	#find all the players in the gameworld
	for child in get_children():
		if(child.name.find("Player") != -1):
			child.set_physics_process(ballAndPlayerPhysics)