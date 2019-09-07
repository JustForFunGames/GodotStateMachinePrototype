extends KinematicBody2D
class_name Player

export var movement_speed = 500
export var rotation_speed = 5
export var munition = 1

func walk():
	var direction = 1
	
	if $PlayerStateMachine.has_method("get_movement_direction"):
		direction = $PlayerStateMachine.get_movement_direction()
		
	var movement = Vector2.UP * direction
	movement = movement.rotated(deg2rad(rotation_degrees))
	move_and_slide(movement * movement_speed)
	
func turn():
	print("turn")
	var direction = 1
	if $PlayerStateMachine.has_method("get_rotation_direction"):
		direction = $PlayerStateMachine.get_rotation_direction()
	
	var rotation = rotation_degrees + rotation_speed * direction
	rotation_degrees = rotation

func shoot():
	if munition > 0:
		munition -= 1