extends Node

func get_mapfile(map_title, user=false):
	var path = "res://Scenes/Levels/%s_map.tscn"
	return path % map_title.replace(" ", "").to_lower()
	
