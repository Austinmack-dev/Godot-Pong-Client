extends Node2D

var pLobbies = []
var my_id
var MAX_PLAYERS = Networking.MAX_PLAYERS
const PlayerLobbyScene = preload("res://Scenes/Lobby/PlayerLobby.tscn")
const GameWorld = preload("res://Shared/Scenes/GameWorld/GameWorld.tscn")
const PlayerScene = preload("res://Shared/Scenes/PlayerScenes/Player.tscn")
const BallScene = preload("res://Shared/Scenes/Ball/Ball.tscn")
const PlayerScoreZone = preload("res://Shared/Scenes/GameWorld/PlayerScoreZone/PlayerScoreZone.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	Networking.connect("setup_ui",self,"_setup_ui")
	Networking.connect("update_ui",self,"_update_ui")
	Networking.connect("start_game",self,"_start_game")
	my_id = get_tree().multiplayer.get_network_unique_id()
	print ("my id: " + str(my_id))
	#set_network_master(get_tree().multiplayer.get_network_unique_id())
	print ("network master: " + str(get_network_master()))
	#print ("\n network master: " + str(get_tree().multiplayer.get_network_master()))
	
func _update_ui(info,id):
	var keys = info.keys()
	#happens everytime 1 client disconnects
	if(info.size() < MAX_PLAYERS):
		
		var size = info.size() 
		get_node("PlayerLobby" + str(size)).free()
		for i in range(0,keys.size()):
			var pLobby = get_node("PlayerLobby" + str(i))
			pLobby.get_node("PlayerNumber").text = "Player Number is: " + str(i+1)
			pLobby.get_node("PlayerName").set_text("Player Name is: " + info[keys[i]].name)
			pLobby.get_node("ReadyButton").visible = false
			pLobby.get_node("PlayerReadyLabel").text = ""
			pLobby.get_node("PlayerReadyLabel").visible = false
	else:
		for i in range(0,keys.size()):
			var pLobby = get_node("PlayerLobby" + str(i))
			if(info[keys[i]].ready == true):
				pLobby.get_node("PlayerReadyLabel").visible = true
				pLobby.get_node("PlayerReadyLabel").text = "Player name: " + info[keys[i]].name + " is ready!!!!"
				pLobby.get_node("ReadyButton").visible = false
			elif((info[keys[i]].ready == false) and my_id == keys[i]):
				pLobby.get_node("ReadyButton").visible = true
				pLobby.get_node("PlayerReadyLabel").visible = false
			else:
				pLobby.get_node("PlayerReadyLabel").text = ""



func _setup_ui(info):
	var keys = info.keys()
	
	#if there are more than one client connected
	if(get_tree().multiplayer.get_network_connected_peers().size() >= 1):
		
		for i in range(0,keys.size()):
			if(has_node("PlayerLobby" + str(i))):
				pass
			#Create a PlayerLobbyScene for each individual Player and add it to the Lobby Node
			else:
				var newLobby = PlayerLobbyScene.instance()
				newLobby.name = "PlayerLobby" + str(i)
				newLobby.position = Vector2(0,60*i)
				newLobby.get_node("PlayerNumber").text = "Player Number is: " + str(i+1)
				newLobby.get_node("PlayerName").set_text("Player Name is: " + info[keys[i]].name)
				add_child(newLobby)	
	if(MAX_PLAYERS == keys.size()):
		for i in range(0, keys.size()):
			var pLobby = get_node("PlayerLobby" + str(i))
			if(my_id == keys[i]):
				pLobby.get_node("ReadyButton").visible = true

func _start_game(info):
	if(has_node("/root/GameWorld")):
		get_node("/root/GameWorld").show()
	else:
		var keys = info.keys()
	#	print("BEFORE ADD - START GAME")
	#	get_tree().get_root().print_tree_pretty()
		var game = GameWorld.instance()
		var num_players = info.size()
		
		get_tree().get_root().add_child(game)
		var ball = BallScene.instance()
		game.add_child(ball)
		ball.set_physics_process(false)
		for i in range(0,num_players):
			var player = PlayerScene.instance()
			player.name = "Player" + str(keys[i])
			player.get_node("PlayerName").text = info[keys[i]].name
			player.position = Vector2(900*i, player.position.y)
			var pz = game.get_node("Score" + str(i+1))
			pz.name = "Score-"+str(keys[i])
			pz.text = info[keys[i]].name + "'s Score: " + str(0)
			game.add_child(player)
			player.set_physics_process(false)
			if(i == 1):
				var playerSprite = player.get_node("Sprite")
				playerSprite.texture = preload("res://Shared/paddle2.png")
		
	#	var player1ScoreLabel = game.get_node("Score-" + str(keys[0]))
	#	var player2ScoreLabel = game.get_node("Score-" + str(keys[1]))
	#
	#
	#	player1ScoreLabel.text = info[keys[0]].name + " 's Score: " + str(0)
	#	player2ScoreLabel.text = info[keys[1]].name + " 's Score: " + str(0)
		for i in range(num_players-1,-1,-1):
			var scoreZone = PlayerScoreZone.instance()
			scoreZone.name = "ScoreZone-"+str(keys[i])
			scoreZone.position = Vector2(1000-(1000*i),scoreZone.position.y)
			game.add_child(scoreZone)
		hide()
#	print("AFTER ADD - START GAME")
#	get_tree().get_root().print_tree_pretty()