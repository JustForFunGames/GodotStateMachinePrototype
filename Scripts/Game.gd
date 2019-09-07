extends Node2D

var version = "Prototype A"

func _on_change_state(state):
	var label_text = "Version: %s; State: %s"
	$"UserInterfaces/PrototypeUI/VBoxContainer/Label".text = \
		label_text % [version, state]
