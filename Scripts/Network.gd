extends Node

const SERVER_IP = "127.0.0.1"
const SERVER_PORT = 31400
const MAX_PLAYERS = 2

var players = {}
var player_info = {
	name = "Player 1",
	position = Vector2(0,0)
}

signal creating_server
signal connecting_to_server
signal server_created
signal connected_to_server

func _process(delta):
	if Input.is_action_just_pressed("Network_CreateServer"):
		create_server()
	elif Input.is_action_just_pressed("Network_Connect"):
		connect_to_server()

func create_server():
	emit_signal("creating_server")
	player_info.name = "Player 1"
	players[1] = player_info
	
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(SERVER_PORT, MAX_PLAYERS)
	emit_signal("server_created")
	get_tree().set_network_peer(peer)
	
func connect_to_server():
	emit_signal("connecting_to_server")
	player_info.name = "Player 2"
	get_tree().connect("connected_to_server", self, "_connected_to_server")
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(SERVER_IP, SERVER_PORT)
	get_tree().set_network_peer(peer)
	
func _connected_to_server():
	var id = get_tree().get_network_unique_id()
	emit_signal("connected_to_server")
	players[id] = player_info
	rpc("_send_player_info", id, player_info)
	
remote func _send_player_info(id, info):
	if get_tree().is_network_server():
		for peer_id in players:
			rpc_id(id, '_send_player_info', peer_id, players[peer_id])
	
	var new_player = load("res://Scenes/Units/Soldier.tscn").instance()
	new_player.name = "Player %s" % str(id)
	new_player.set_network_master(id)
	get_tree().get_root().add_child(new_player)
	
	 

func _ready():
	pass
