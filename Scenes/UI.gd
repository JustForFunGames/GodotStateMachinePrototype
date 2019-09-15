extends Node

var game_state = "..."
var player_count = 0
var game_label_text = "Game State: %s\n%s Players"
var active_countdown = null

func _process(delta):
	if active_countdown:
		set_timer_label(floor(active_countdown.time_left))
	else:
		set_timer_label("")
		
func _ready():
	get_tree().get_root().find_node("VersionLabel", true, false).text = ""
	get_tree().get_root().find_node("DebugLabel", true, false).text = ""
	get_tree().get_root().find_node("TimerLabel", true, false).text = ""
	
	get_tree().get_root().find_node("ActionLabel", true, false).text = ""
	get_tree().get_root().find_node("NetworkStatusLabel", true, false).text = ""

func update_player_count(count):
	player_count = count
	get_tree().get_root().find_node("GameLabel", true, false).text = game_label_text % [game_state, str(player_count)]

func set_timer_label(seconds):
	get_tree().get_root().find_node("TimerLabel", true, false).text = str(seconds)
	
func _on_change_connection(connection):
	get_tree().get_root().find_node("NetworkStatusLabel", true, false).text = connection

func enter_game_state(state):
	# game_state = state.replace("_", " ")
	game_label_text = ""
	if state in ["walk_and_shoot", "walk", "idle", "shoot"]:
		game_label_text = "Your turn!"
	elif state == "finish_round":
		game_label_text = "Good job!"
	if state in ["shoot", "action"]:
		set_timer_label("")
	get_tree().get_root().find_node("GameLabel", true, false).text = game_label_text

# handle event if a unit state is entered
func enter_unit_state(state, unit, focused):
	var state_text = ""
	if state in ["walk_and_shoot", "walk", "turn", "idle"]:
		state_text = "Move, then shoot!"
	elif state in ["shoot", "wait"]:
		state_text = state + "ing ..."
	elif state in ["finished", "done"]:
		state_text = "waiting for enemy ..."
	get_tree().get_root().find_node("DebugLabel", true, false).text = state_text

func countdown(timer):
	active_countdown = timer