extends Node2D

var version = "Prototype A"

func _ready():
	# todo: replace the node selection with something more fun
	$"UI/Prototype/VBoxContainer/HBoxContainer/VersionLabel".text = version
	$"UI/Prototype/VBoxContainer/HBoxContainer/DebugLabel".text = ""
	$"UI/Prototype/VBoxContainer/HBoxContainer/TimerLabel".text = ""

func _on_change_state(state):
	var text = "State: %s"
	$"UserInterfaces/PrototypeUI/VBoxContainer/HBoxContainer/Debug".text = text % state

func _on_change_timer(seconds):
	var text = ""
	
	if seconds > 1:
		text = str(seconds)
	
	$"UserInterfaces/PrototypeUI/VBoxContainer/HBoxContainer/Debug".text = text
