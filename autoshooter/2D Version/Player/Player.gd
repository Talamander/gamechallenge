extends KinematicBody2D

export var rotation_speed:= 90.0

var motion = Vector2.ZERO
var acceleration:= 5000
var speed:= 360.0
var target = Vector2.ZERO
var active = false


func _physics_process(delta: float) -> void:
	var input_vector = get_input_vector()
	
	
	#Vector2.ZERO is true when no move key is being pressed
	if input_vector == Vector2.ZERO:
		apply_friction(acceleration * delta)
	else:
		calc_movement(input_vector * acceleration * delta)
		
	motion = move_and_slide(motion)
	
	
	if !active:
		return
	else:
		$Position2D.look_at(target)
	
	#rotate_ray(delta)



func rotate_ray(delta: float) -> void:
	$Position2D.rotation_degrees += rotation_speed * delta

func get_input_vector():
	#input vector is direction of key input (WASD)
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	return input_vector.normalized()
	
func apply_friction(amount):
	#Get the player movement moving smoothly
	if motion.length() > amount:
		motion -= motion.normalized() * amount
	else:
		motion = Vector2.ZERO

func calc_movement(acceleration):
	#Uses the acceleration to ramp up to the speed, so it's not instantaneous
	motion += acceleration
	motion = motion.clamped(speed)

func _on_Area2D_body_entered(body):
	active = true
	target = body.global_position


func _on_Area2D_body_exited(body):
	active = false
	pass # Replace with function body.
