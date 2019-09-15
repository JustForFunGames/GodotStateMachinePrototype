extends KinematicBody2D
class_name Unit

export var movement_speed = 500
export var rotation_speed = 5

func walk():
	var direction = 1

	if $UnitStateMachine.has_method("get_movement_direction"):
		direction = $UnitStateMachine.get_movement_direction()

	var movement = Vector2.UP * direction
	movement = movement.rotated(deg2rad(rotation_degrees))
	move_and_slide(movement * movement_speed)

func turn():
	var direction = 1
	if $UnitStateMachine.has_method("get_rotation_direction"):
		direction = $UnitStateMachine.get_rotation_direction()

	var rotation = rotation_degrees + rotation_speed * direction
	rotation_degrees = rotation

func action():
	get_tree().call_group("UnitState", "on_unit_action")

func done():
	return false
