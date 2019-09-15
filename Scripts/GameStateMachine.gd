extends StateMachine
class_name GameStateMachine

# timer to move the character
onready var move_timer = null
export(float, 10) var last_chance_to_shoot = 4

# your local player
export(String, "Blue", "Red", "Green", "Yellow") var player = "Blue"

# unit that is currently selected
var selected = null

# active playing player
var active_player = "Blue"

# order of players
var player_order = []

# player information about all players
var players = {}

# initialize timer for timing player movement
func initalize_timer():
	move_timer = Timer.new()
	move_timer.set_name("InGame_Move_Timer")
	var timer_group = get_tree().get_root().find_node("Timer", true, false)
	move_timer.wait_time = timer_group.get_node("Move").wait_time - last_chance_to_shoot
	move_timer.one_shot = true
	move_timer.connect("timeout", self, "_on_timeout", ["shoot"])  
	timer_group.add_child(move_timer)

func _ready():
	var parent = get_parent()
	initalize_timer()
	
	var map = parent.initialize_map()
	players = map.get_players()
	player_order = map.get_players().keys()
	if not player in player_order:
		player = players.keys()[0]
	
	var _states = [
		"start_round",
		"walk_and_shoot",
		"shoot",
		"finish_round",
		"waiting_for_enemy",
		"show_enemy_actions",
		"game_over",
		"reconnecting"
	]
	
	for _state in _states:
		add_state(_state)
	call_deferred("set_state", states.start_round)

func next_player():
	if not player_order.size():
		player_order = players.keys()
	if player_order.find(active_player) >= 0:
		var active_player_id = player_order.find(active_player) + 1
		if active_player_id > player_order.size():
			active_player_id = 0
		active_player = player_order[active_player_id]
		return active_player
	else:
		return player_order[0]

func finish_round():
	set_state(states.finish_round)

func _state_logic(delta):
	pass

func _get_transition(delta):
	return null

func _enter_state(state, current):
	get_tree().call_group("GameState", "enter_game_state", current)

func enter_game_state(state):
	if active_player == player:
		match state:
			states.start_round:
				countdown($"../Timer/Wait")
			states.walk_and_shoot:
				_select_next()
				countdown($"../Timer/Move")
				move_timer.start()
			states.shoot:
				move_timer.stop()
				$"../Timer/Move".stop()
				players[player].units[selected].get_node("UnitStateMachine").set_state("action")

func countdown(timer):
	get_tree().call_group("GameState", "countdown", timer)
	timer.start()

func _exit_state(current, next):
	pass

# unselect all units
func unselect_all_units():
	for unit in players[player].units:
		unit.get_node("UnitStateMachine").unfocus()
		unit.get_node("Selected").hide()

# select next unit that is under players control
func _select_next():
	if selected == null:
		selected = randi() % players[player].units.size()
	else:
		selected += 1
	if selected >= players[player].units.size():
		selected = 0
	unselect_all_units()
	var selected_unit = players[player].units[selected]
	selected_unit.get_node("UnitStateMachine").focus()
	selected_unit.get_node("Selected").show()

func on_unit_action():
	print("Unit entered shoot")
	set_state(states.shoot)

func _on_timeout(next):
	set_state(next)