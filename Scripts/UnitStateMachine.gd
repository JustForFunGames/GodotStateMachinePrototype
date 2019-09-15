extends StateMachine
class_name UnitStateMachine

signal enter_state
signal focused(name)
signal unfocused(name)

const ACTION_FORWARD = "Forward"
const ACTION_BACK = "Back"
const ACTION_LEFT = "Left"
const ACTION_RIGHT = "Right"
const ACTION_SHOOT = "Shoot"

const EPSILON = 0.01

export var focused = false
var game_state = null

func focus():
	print("focus unit " + parent.name)
	focused = true
	set_state(states.idle)
	emit_signal("focused", name)

func unfocus():
	print("unfocus unit " + parent.name)
	focused = false
	set_state(states.waiting)
	emit_signal("unfocused", name)

func _ready():
	add_state("waiting")
	add_state("idle")
	add_state("walk")
	add_state("action")
	add_state("finished")
	call_deferred("set_state", states.idle)
	
func _state_logic(delta):
	# walking and turning
	if state == states.walk:
		if Input.is_action_pressed(ACTION_FORWARD) or Input.is_action_pressed(ACTION_BACK):
			parent.walk()
		if Input.is_action_pressed(ACTION_LEFT) or Input.is_action_pressed(ACTION_RIGHT):
			parent.turn()
	# perform action (like shooting)
	elif state == states.action:
		if Input.is_action_pressed(ACTION_SHOOT):
			parent.action()
		else:
			set_state(states.finished)
	# finished
	elif state == states.finished:
		pass

func get_movement_direction():
	return get_direction("action_pressed", ACTION_FORWARD, ACTION_BACK)

func get_rotation_direction():
	return get_direction("action_pressed", ACTION_RIGHT, ACTION_LEFT)

func get_direction(function="", positive=null, negative=null):
	var direction = 0

	if function and positive and negative:
		if call(function, positive):
			direction += 1

		if call(function, negative):
			direction -= 1

		if direction > -1 * EPSILON and direction < EPSILON:
			direction = 0.0

		direction = int(sign(direction))

	return direction

func enter_game_state(state):
	game_state = state

func _get_transition(delta):
	if not focused:
		return states.waiting
		
	if game_state == "walk_and_shoot":
		if state in [states.idle, states.walk] and action_pressed(ACTION_SHOOT):
			get_tree().call_group("UnitState", "on_unit_action")
			return states.action
		if state == states.idle and is_walking():
			return states.walk
		if state == states.walk and not is_walking():
			return states.idle
	elif game_state == 'shoot' and not action_pressed(ACTION_SHOOT):
		get_tree().call_group("GameState", "finish_round")
		return states.finished

func is_walking():
	return get_direction("action_pressed", ACTION_FORWARD, ACTION_BACK) \
		or get_direction("action_pressed", ACTION_LEFT, ACTION_RIGHT)

func action_pressed(action_name):
	return Input.is_action_pressed(action_name) 

func _enter_state(state, current):
	get_tree().call_group("UnitState", "enter_unit_state", state, parent.name, focused)