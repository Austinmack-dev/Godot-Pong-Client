extends Node2D

var pLobbies = []
var my_id
var MAX_PLAYERS = 0
const PlayerLobbyScene = preload("res://Scenes/Lobby/PlayerLobby.tscn")
const GameWorld = preload("res://Shared/Scenes/GameWorld/GameWorld.tscn")

var game

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
	#THIS IS ONLY WHEN TESTING THE TESTING CLIENT
	if(Networking.extra == false):
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
	

func _setup_ui(info, max_players):
	print("in setup_UI")
	if(Networking.extra == false):
		MAX_PLAYERS = max_players
		print("max players in lobby: " + str(MAX_PLAYERS))
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


func _start_game(info, playerPosNames,ball_pos_moveDir):
	print("playerPosNames.size() in _start_game: " + str(playerPosNames.size()))
	#if the game is being restarted, restart it
	if(has_node("/root/GameWorld")):
		game.show()
		get_node("/root/LobbyNode").hide()
		game.restart(playerPosNames,ball_pos_moveDir)
	#otherwise, setup the game initially
	else:
		game = GameWorld.instance()
		var num_players = info.size()
		get_tree().get_root().add_child(game)
		game.setup(playerPosNames, ball_pos_moveDir)
		hide()
	if Networking.extra == true:
		print("I am in the Networking.extra == true if statement")
		game.hide()
		var dummy = preload("res://Dummy.tscn")
		var dummyInst = dummy.instance()
		get_tree().get_root().add_child(dummyInst)