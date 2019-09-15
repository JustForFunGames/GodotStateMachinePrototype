extends Node
class_name Game

# game version
export var version = "v0.1.0"

# map from node path
export(NodePath) var map = null

# map from file
export(String, FILE) var map_file = null

var _map = null

func _ready():
	initialize_map()
	
func initialize_map():
	if not _map:
		if typeof(map) == TYPE_NODE_PATH and not map.is_empty():
			_map = get_node(map)
		elif typeof(map_file) == TYPE_STRING:
			_map = load(map_file).instance()
			get_tree().get_root().find_node("Map", true, false).add_child(_map)
		else:
			_map = get_tree().get_root().find_node("Map", true, false).get_children()[0]
	return _map