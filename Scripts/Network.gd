extends Node

const SERVER_IP = "127.0.0.1"
const SERVER_PORT = 31400
const MAX_PLAYERS = 2

var players = {}
var player_info = {
	name = "Player 1",
	position = Vector2(0,0)
}

var game_data = {
	map = "Test Map"
}

signal creating_server
signal connecting_to_server
signal server_created
signal connected_to_server

func _ready():
	players = {}
	player_info = {
		name = "Player 1",
		position = Vector2(0,0)
	}

func _process(delta):
	if Input.is_action_just_pressed("Network_CreateServer"):
		create_server()
	elif Input.is_action_just_pressed("Network_Connect"):
		connect_to_server()

# create a server peer
func create_server():
	get_tree().call_group("Network", "creating_server", SERVER_IP, SERVER_PORT, MAX_PLAYERS)
	emit_signal("creating_server")
	
	player_info.name = "Player 1"
	players[1] = player_info
	
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(SERVER_PORT, MAX_PLAYERS)
	get_tree().set_network_peer(peer)
	
	emit_signal("server_created")
	print("Server created at %s" % SERVER_IP)
	
# connect to a server
func connect_to_server():
	get_tree().call_group("Network", "connecting_to_server", SERVER_IP, SERVER_PORT)
	emit_signal("connecting_to_server")
	
	player_info.name = "Player 2"
	
	get_tree().connect("connected_to_server", self, "_connected_to_server")
	
	print("Connecting to %s ..." % SERVER_IP)
	
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(SERVER_IP, SERVER_PORT)
	get_tree().set_network_peer(peer)

# send player info if connected
func _connected_to_server():
	get_tree().call_group("Network", "connection_successful", SERVER_IP, SERVER_PORT)
	
	var id = get_tree().get_network_unique_id()
	
	print("Connected as %s to server %s" % [id, SERVER_IP])
	emit_signal("connected_to_server")
	
	players[id] = player_info
	rpc("_send_player_info", id, player_info)

# send player information
remote func _send_player_info(id, info):
	if get_tree().is_network_server():
		# send any player information on the server to the connected client
		for peer_id in players:
			rpc_id(id, '_send_player_info', peer_id, players[peer_id])

	print("%s:%s > add player %s ..." % [SERVER_IP, get_tree().get_network_unique_id(), id])
	# create a puppet for the master on each client
	var new_player = load("res://Scenes/Units/Soldier.tscn").instance()
	new_player.name = "Player %s" % str(id)
	new_player.set_network_master(id)
	get_tree().get_root().add_child(new_player)
