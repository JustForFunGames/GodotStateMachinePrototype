extends Unit
class_name Soldier

var aim = null
var aiming = false

export var shooting_speed = 750
export var shot_scale = 1
export var damage = 10
export var core_damage_factor = 1.5
export var light_damage_factor = 0.2
export var live = 10

var finished = false
var has_shot = false
var is_shooting = false

var shooting_direction = Vector2.UP
var shooting_movement = Vector2.ZERO

onready var parent = get_parent()


#func _physics_process(delta):

func action():
	add_aiming_area()
	is_shooting = true
	if is_shooting:
		shooting_movement = shooting_direction.normalized() * shooting_speed
		aim.move_and_slide(shooting_movement)
	# aiming = $"UnitStateMachine".state == $"UnitStateMachine".states.action

func add_aiming_area():
	if not aim:
		aim = load("res://Scenes/Items/Shot.tscn").instance()
		aim.set_name("AimingArea")
		aim.get_node("Circle").self_modulate = parent.color
		aim.scale.x = shot_scale
		aim.scale.y = shot_scale
		shooting_direction = Vector2.UP.rotated(deg2rad(rotation_degrees))
		add_child(aim)
		