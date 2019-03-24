extends Node2D

var timer = Timer
var timeLabel
var gameStartLabel
var nextPointLabel
const BallScene = preload("res://Shared/Scenes/Ball/Ball.tscn")
const EndGameScene = preload("res://Shared/Scenes/EndGame/EndGame.tscn")
const PlayerScene = preload("res://Shared/Scenes/PlayerScenes/Player.tscn")
const PlayerScoreZone = preload("res://Shared/Scenes/GameWorld/PlayerScoreZone/PlayerScoreZone.tscn")
var ball
var playerList = []
var scoreLabelList = []
var scoreNameLabelList = []
var scoreZoneList = []
var keys


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

puppet func _end_game(player_name):
#	print("playerPosName.size() in _end_game " + str(playerPosNames.size()))
#	for i in range(0,playerPosNames.size()):
#		var player = get_node(playerPosNames[i].playerName)
#		player.position = playerPosNames[i].pos
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

func setup_ball(ball_pos_moveDir):
	ball.position = ball_pos_moveDir[0]
	ball.moveDir = ball_pos_moveDir[1]

func print_player_list():
	print("PlayerList size::: " + str(playerList.size()))
	for i in range(0,playerList.size()):
		print("Player name: " + playerList[i].name)
		print("Player pos: " + str(playerList[i].position))

func setup_player(pName, pPos, pGameName):
	var player = PlayerScene.instance()
	player.name = pName
	player.position = pPos
	player.get_node("PlayerName").text = pGameName
	print("player name in setup_player: " + player.name)
	print("player pos in setup_player: " + str(player.position))
	add_child(player)
	player.set_physics_process(false)
	playerList.append(player)

func reset_player(listOfPlayerInfo):
	for i in range(0,playerList.size()):
		playerList[i].position = listOfPlayerInfo[i].pos

func setup_score_label(initNameInt, newNameNumber):
	var pScoreLabel = get_node("Score" + str(initNameInt))
	pScoreLabel.name = "Score-"+str(newNameNumber)
	pScoreLabel.text = str(0)
	scoreLabelList.append(pScoreLabel)

func setup_scoreName_label(initNameInt, nameText):
	var pScoreNameLabel = get_node("ScoreLabel" + str(initNameInt))
	pScoreNameLabel.text = nameText + "'s Score: "
	scoreNameLabelList.append(pScoreNameLabel)

func setup_scoreZone(id,i):
	var scoreZone = PlayerScoreZone.instance()
	scoreZone.name = "ScoreZone-"+str(id)
	scoreZone.position = Vector2(1000-(1000*i),scoreZone.position.y)
	scoreZoneList.append(scoreZone)
	add_child(scoreZone)

func setup(listOfPlayerInfo, ball_pos_moveDir):
	keys = Networking.player_list_from_server.keys()
	ball = BallScene.instance()
	add_child(ball)
	setup_ball(ball_pos_moveDir)
	ball.set_physics_process(false)
	
	
	for i in range(0,Networking.player_list_from_server.size()):
		var pName = listOfPlayerInfo[i].playerName
		var pPos = listOfPlayerInfo[i].pos
		var pGameName = listOfPlayerInfo[i].playerGameName
		setup_player(pName, pPos, pGameName)
		setup_score_label(i+1, keys[i])
		setup_scoreName_label(i+1,pGameName)
#		var pScoreNameLabel = get_node("ScoreLabel" + str(i+1))
#		pScoreNameLabel.text = listOfPlayerInfo[i].playerGameName + "'s Score: "
#		scoreNameLabelList.append(pScoreNameLabel)
		
		if(i == 1):
			var playerSprite = playerList[i].get_node("Sprite")
			playerSprite.texture = preload("res://Shared/paddle2.png")
	for i in range(Networking.player_list_from_server.size()-1,-1,-1):
		setup_scoreZone(keys[i],i)
#		var scoreZone = PlayerScoreZone.instance()
#		scoreZone.name = "ScoreZone-"+str(keys[i])
#		scoreZone.position = Vector2(1000-(1000*i),scoreZone.position.y)
#		scoreZoneList.append(scoreZone)
#		add_child(scoreZone)
	print_player_list()

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