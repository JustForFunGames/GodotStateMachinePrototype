extends Node
class_name StateMachine

var state = null setget set_state

var previous = null
var states = {}

onready var parent = get_parent()

func _physics_process(delta):
	if state != null:
		_state_logic(delta)
		var transition = _get_transition(delta)
		if transition:
			set_state(transition)

func _state_logic(delta):
	pass

func _get_transition(delta):
	return null

func _enter_state(state, current):
	pass

func _exit_state(current, next):
	pass

func set_state(next):
	if previous != null:
		_exit_state(state, next)
	
	previous = state
	state = next
	
	if next != null:
		_enter_state(previous, state)

func add_state(name):
	states[name] = name
