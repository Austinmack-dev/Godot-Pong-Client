extends Node2D

signal setup_ui(info)
signal update_ui(info,id)
signal clear_player_lobby()
signal start_game(info)

var client_info = {name="Hello", ready = false}
var MAX_PLAYERS = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().multiplayer.connect("connected_to_server", self, "_connected_ok")	
	get_tree().multiplayer.connect("connection_failed", self, "_failed_to_connect_to_server")
	get_tree().multiplayer.connect("network_peer_connected", self, "_peer_connected")
	get_tree().multiplayer.connect("network_peer_disconnected", self, "_server_disconnected")
	get_tree().multiplayer.connect("server_disconnected",self,"_no_longer_connected")
	
	
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

puppet func _send_client_info(info):
	emit_signal("setup_ui",info)

puppet func _send_client_ready(info, id):
	emit_signal("update_ui",info, id)
	
puppet func _send_client_start_game(info):
	emit_signal("start_game",info)