extends Node2D

export var title = "Test Map"
export var version = "0.1.0"

var players = null
var player_order = null

func _ready():
	players = get_players()
	player_order = players.keys()

# return all units in <parent>
# :param parent: name of a parent node of the units. if null, use the local player
func _collect_units(parent=null):
	var group_units = null
	if parent == null:
		var game = get_tree().get_root().find_node("GameStateMachine", true, false)
		parent = game.active_player
	var groups = get_tree().get_root().find_node(parent, true, false)
	if groups == null:
		return null
	var units = groups.get_children()
	for unit in units:
		unit.get_node("Selected").self_modulate = unit.get_parent().color
	return units

# load players and return count of them
func get_players():
	var all_units = get_tree().get_root().find_node("Units", true, false)

	if all_units == null:
		return
	
	var groups = all_units.get_children()
	
	var players = {}
	for player in groups:
		 players[player.name] = {"units": _collect_units(player.name)}
	return players
