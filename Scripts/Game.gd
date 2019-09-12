extends Node2D

var version = "Prototype A"

var state_text = ""
var unit_text = ""
var action_text = ""
var network_text = "disconnected"

var units = []
var selected = null
export var player = "Red"
var players = {}

func _ready():
	# todo: replace the node selection with something more fun
	$"UI/BottomBar/VersionLabel".text = version
	$"UI/BottomBar/DebugLabel".text = ""
	$"UI/BottomBar/TimerLabel".text = ""
	
	var player_count = get_players()
	
	get_tree().get_root().find_node("GameLabel", true, false).text = "Game State: WALK\n%s Players" % player_count
	get_tree().get_root().find_node("ActionLabel", true, false).text = "use WASD to walk,\nthen SPACE to shoot\nTAB to select next unit"
	get_tree().get_root().find_node("NetworkStatusLabel", true, false).text = "Network disconnected\nPress 1 to create a server\nPress 2 to connect to a server"
	
	collect_units()

# return all units in <parent>
# :param parent: name of a parent node of the units. if null, use the local player 
func collect_units(parent=null):
	var group_units = null
	if parent == null:
		parent = player
	group_units = get_tree().get_root().find_node(parent, true, false)
	if group_units == null:
		return 0
	group_units = group_units.get_children()
	for unit in group_units:
		units.append(unit)
	return units.size()
	
# load players and return count of them
func get_players():
	var all_units = get_tree().get_root().find_node("Units", true, false)
	
	if all_units == null:
		return
	var groups = all_units.get_children()
	for player in groups:
		 players[player.name] = player.name
	return players.keys().size()

# update ui label for the unit state
func update_state_label():
	var state_labeltext = state_text
	if state_text == "idle":
		state_labeltext = "stand"
	var text = "Unit \"%s\" is %sing"
	return text % [action_text, unit_text, state_labeltext, network_text]
	

# handle event if a unit state is entered
func _on_change_state(state):
	if state in ["walk", "idle"]:
		action_text = "walk"
	elif state in ["shoot"]:
		action_text = "shoot"
	else:
		action_text = ""
	state_text = state
	$"UI/BottomBar/DebugLabel".text = update_state_label()
	
func _on_change_connection(connection):
	network_text = connection
	update_state_label()
	
func _on_change_timer(seconds):
	var text = ""
	
	if seconds > 1:
		text = str(seconds)
	
	$"UI/BottomBar/TimerLabel".text = text

# unselect all units
func unselect_all():
	for unit in units:
		unit.get_node("UnitStateMachine").unfocus()

# select next unit that is under players control
func select_next():
	if selected == null:
		selected = randi() % units.size()
	else:
		selected += 1
	if selected >= units.size():
		selected = 0
	unselect_all()
	units[selected].get_node("UnitStateMachine").focus()

func _process(delta):
	if Input.is_action_just_pressed("select_next"):
		select_next()