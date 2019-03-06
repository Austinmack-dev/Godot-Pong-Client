extends Button


func _on_joinButton_pressed():
	if(get_node("/root/Node2D/playerNameBox").text != ""):
		Networking.client_info.name = get_node("/root/Node2D/playerNameBox").text;
	#switch to new scene
	get_tree().change_scene("res://Scenes/Lobby/Lobby.tscn")
	
	#connect to server
	var client = NetworkedMultiplayerENet.new()
	client.create_client("127.0.0.1", 4242)
	get_tree().multiplayer.set_network_peer(client)