extends StateMachine
class_name PlayerStateMachine

signal enter_state

const ACTION_FORWARD = "Forward"
const ACTION_BACK = "Back"
const ACTION_LEFT = "Left"
const ACTION_RIGHT = "Right"
const ACTION_SHOOT = "Shoot"

const EPSILON = 0.01

func _ready():
	add_state("idle")
	add_state("walk")
	add_state("shoot")
	call_deferred("set_state", states.idle)

func _state_logic(delta):
	if state == states.walk:
		if Input.is_action_pressed(ACTION_FORWARD) or Input.is_action_pressed(ACTION_BACK):
			parent.walk()
		if Input.is_action_pressed(ACTION_LEFT) or Input.is_action_pressed(ACTION_RIGHT):
			parent.turn()
	if state == states.shoot:
		if Input.is_action_pressed(ACTION_SHOOT):
			parent.shoot()

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

func action_pressed(action_name):
	return Input.is_action_pressed(action_name)

func has_shot():
	return parent.munition == 0

func _get_transition(delta):
	match state:
		states.idle:
			if get_direction("action_pressed", ACTION_FORWARD, ACTION_BACK):
				return states.walk
			if get_direction("action_pressed", ACTION_LEFT, ACTION_RIGHT):
				return states.walk
		states.walk:
			if not (Input.is_action_pressed(ACTION_FORWARD) or Input.is_action_pressed(ACTION_BACK) or
				Input.is_action_pressed(ACTION_LEFT) or Input.is_action_pressed(ACTION_RIGHT)):
				return states.idle
		states.shoot:
			if has_shot():
				return states.idle

func _enter_state(state, current):
	emit_signal("enter_state", current)

func _exit_state(current, next):
	pass