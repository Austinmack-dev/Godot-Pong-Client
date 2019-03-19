extends Node2D

var timer = Timer
var timeLabel
var gameStartLabel
var nextPointLabel
var countDown = 5
const EndGameScene = preload("res://Shared/Scenes/EndGame/EndGame.tscn")

func _ready():
	gameStartLabel = get_node("GameStartLabel")
	nextPointLabel = get_node("NextPointLabel")
	timeLabel = get_node("TimerLabel")
#	timer = Timer.new()
#	timer.connect("timeout", self, "timer_timedout")
#	add_child(timer)
#	timer.start(5.0)

puppet func _player_scored(client_id, score):
	#print("IN PLAYER SCORED RPC")
	var pScore = get_node("Score-" + str(client_id))
	var textWithoutScore = pScore.text.substr(0,pScore.text.length()-1)
	print(textWithoutScore)
	pScore.text = textWithoutScore + str(score)

puppet func _player_win(player_name):
	#hide the game world
	hide()
	#show the end game screen
	var end = EndGameScene.instance()
	get_tree().get_root().add_child(end)
	var playerWinLabel = end.get_node("PlayerWinLabel")
	playerWinLabel.text = player_name + " wins the game!!!"

puppet func _reset_ball_on_client():
	var ball = get_node("Ball")
	ball.position = Vector2(0,0)
	ball.show()
	ball.set_physics_process(false)
	set_physics_process(true)
	timeLabel.show()
	nextPointLabel.show()
	gameStartLabel.hide()
	for child in get_children():
		if(child.name.find("Player") != -1):
			child.set_physics_process(false)
	
puppet func _send_client_time_left(timeLeft):
	timeLabel.text = str(timeLeft)
	
puppet func _timer_timed_out_on_server():
	set_ball_and_player_physics(true)
	gameStartLabel.hide()
	nextPointLabel.hide()	
	timeLabel.hide()

func set_ball_and_player_physics(ballAndPlayerPhysics):
	var ball = get_node("Ball")
	ball.set_physics_process(ballAndPlayerPhysics)
	#find all the players in the gameworld
	for child in get_children():
		if(child.name.find("Player") != -1):
			child.set_physics_process(ballAndPlayerPhysics)

func reset_ball():
	pass
#	timer.start(2.0)
#	set_physics_process(true)
#	timeLabel.show()
#	nextPointLabel.show()
#	gameStartLabel.hide()
#	var ball = get_node("Ball")
#	ball.position = Vector2(0,0)
#	ball.show()
#	ball.set_physics_process(false)
#	for child in get_children():
#		if(child.name.find("Player") != -1):
#			child.set_physics_process(false)
	
	
func _physics_process(delta):
	pass
#	var timeLeft = int(timer.time_left)
#	timeLabel.text = str(timeLeft)

func timer_timedout():
	pass
#	var ball = get_node("Ball")
#	ball.set_physics_process(true)
#	for child in get_children():
#		if(child.name.find("Player") != -1):
#			child.set_physics_process(true)
#	gameStartLabel.hide()
#	nextPointLabel.hide()	
#	timeLabel.hide()
#	timer.stop()
#	set_physics_process(false)