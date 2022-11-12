extends KinematicBody2D

export var rotation_speed:= 90.0

onready var animPlayer = $AnimationPlayer
onready var fireTimer = $fireTimer

var playerBullet = preload("res://2D Version/Parent Classes/Projectile.tscn")

var motion = Vector2.ZERO
var acceleration:= 5000
var speed:= 360.0
var target = Vector2.ZERO
var active = false
var canFire = true

func _ready():
	pass
	
func _physics_process(delta: float) -> void:
	var input_vector = get_input_vector()
	
	
	#Vector2.ZERO is true when no move key is being pressed
	if input_vector == Vector2.ZERO:
		apply_friction(acceleration * delta)
		animPlayer.play("Idlke")
	else:
		calc_movement(input_vector * acceleration * delta)
		animPlayer.play("Run")
		
	motion = move_and_slide(motion)
	
	#draw_shadow()
	
	
	#checking if there is a body within the area2d -> aka 'active targeting'
	if !active:
		return
	else:
		$Position2D.look_at(target)
	
	animHandler()
	#rotate_ray(delta)
	
	if canFire == true && $Position2D/RayCast2D.is_colliding():
		fire_bullet()



func rotate_ray(delta: float) -> void:
	$Position2D.rotation_degrees += rotation_speed * delta

func get_input_vector():
	#input vector is direction of key input (WASD)
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	return input_vector.normalized()

func animHandler():
	if motion.x == 0:
		animPlayer.play("Idlke")
	elif motion.x > 0:
		$Sprite.set_flip_h(false)
	elif motion.x < 0:
		$Sprite.set_flip_h(true)
	else:
		pass

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


#this function is just to practice drawing shapes with gdScript
func draw_shadow() -> void:
	var center = Vector2(100,100)
	var rad = 100
	var col = Color(255,0,255)
	draw_circle(center, rad, col)
	print("shadow should be here")


func fire_bullet():
	canFire = false
	fireTimer.start()
	var bullet = Global.instance_scene_on_main(playerBullet, $Position2D/RayCast2D.global_position)
	
	bullet.set_rotation($Position2D.global_rotation)
	bullet.velocity = Vector2.RIGHT.rotated(bullet.rotation) * bullet.speed


func _on_fireTimer_timeout():
	canFire = true
	print("made it")
