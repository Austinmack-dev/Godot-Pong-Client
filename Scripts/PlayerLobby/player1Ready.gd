extends Button



func _on_ReadyPlayer1_pressed():
	Networking.client_info.ready = true
	Networking.rpc_id(1, "_send_ready_p1", Networking.client_info, get_tree().get_network_unique_id())
	
