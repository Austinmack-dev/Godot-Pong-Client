extends Node2D

signal setup_ui(info, max_players)
signal update_ui(info, id)
signal clear_player_lobby()
signal start_game(info,playerPosNames,ball_pos_moveDir)
#signal bad_client()
var extra = false
var player_list_from_server
var client_info = {name="Hello", ready = false}
var MAX_PLAYERS = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().multiplayer.connect("connected_to_server", self, "_connected_ok")	
	get_tree().multiplayer.connect("connection_failed", self, "_failed_to_connect_to_server")
	get_tree().multiplayer.connect("network_peer_connected", self, "_peer_connected")
	get_tree().multiplayer.connect("network_peer_disconnected", self, "_server_disconnected")
	get_tree().multiplayer.connect("server_disconnected",self,"_no_longer_connected")
	
puppet func _testing_client():
	get_tree().change_scene("res://Dummy.tscn")
#	print("I am in _testing_client()")
#	emit_signal("bad_client")
#	print("after bad_client is emitted")

func _peer_connected(id):
	pass
	#rpc("_send_client_info", client_info)

func _connected_ok():
	rpc("_send_server_info", client_info, get_tree().multiplayer.get_network_unique_id())
	

func _failed_to_connect_to_server():
	get_tree().multiplayer.set_network_peer(null)
	var connectionStatusLabel = get_node("/root/Node2D/ConnectionStatusLabel")
	connectionStatusLabel.text = "Not able to connect"

func _server_disconnected(id):
	pass
	

func _no_longer_connected():
	get_tree().multiplayer.set_network_peer(null)
	var size = MAX_PLAYERS
	get_node("/root/LobbyNode").free()
	#free the GameWorld
	if(has_node("/root/GameWorld")):
		get_node("/root/GameWorld").free()

puppet func _set_client_to_not_ready():
	client_info.ready = false

puppet func _setup_lobby(info, max_players):
	MAX_PLAYERS = max_players
	print("max players in networking: " + str(MAX_PLAYERS))
	emit_signal("setup_ui",info, max_players)

puppet func _reset_lobby(info, id):
	if(has_node("/root/EndGame")):
		var end = get_node("/root/EndGame")
		end.free()
	if(has_node("/root/LobbyNode")):
		get_node("/root/LobbyNode").show()
	emit_signal("update_ui",info, id)

puppet func _send_client_start_game(info,playerPosNames,ball_pos_moveDir):
	player_list_from_server = info
	if(has_node("/root/EndGame")):
		var end = get_node("/root/EndGame")
		end.hide()
	if(has_node("/root/GameWorld")):
		get_node("/root/GameWorld").show()
	emit_signal("start_game",info,playerPosNames,ball_pos_moveDir)