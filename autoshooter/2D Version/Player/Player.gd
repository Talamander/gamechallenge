extends KinematicBody2D

#This script controls everything to do with the player: movement, firing, targeting, anim

#Preloads
var playerBullet = preload("res://2D Version/Parent Classes/Projectile.tscn")

#Exports
export var rotation_speed:= 90.0
export var gunCount = 3

#Onready Variables
onready var animPlayer = $AnimationPlayer
onready var fireTimer = $fireTimer
onready var holster = $TargetingSystem


#Movement Variables
var motion = Vector2.ZERO
var acceleration:= 5000
var speed:= 360.0


#Combat Variables
var canFire = true



func _ready():
	holster.generate_raycasts(gunCount)



func _physics_process(delta: float) -> void:
	var input_vector = get_input_vector()
	
	#MOVEMENT CHECKS
	if input_vector == Vector2.ZERO:
		apply_friction(acceleration * delta)
		animPlayer.play("Idlke")
	else:
		calc_movement(input_vector * acceleration * delta)
		animPlayer.play("Run")
		
	motion = move_and_slide(motion)
	

	
	animHandler()
	
	




#Animation System
func animHandler():
	if motion == Vector2.ZERO:
		animPlayer.play("Idlke")
	
	#Flips Player Sprite based on direction of motion
	#If knockback from enemy occurs, this system will probably break
	elif motion.x > 0:
		$Sprite.set_flip_h(false)
	elif motion.x < 0:
		$Sprite.set_flip_h(true)
	else:
		pass



#Movement System
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








#Firing System
func fire_bullet():
	canFire = false
	fireTimer.start()
	var bullet = Global.instance_scene_on_main(playerBullet, $Position2D/RayCast2D.global_position)
	
	bullet.set_rotation($Position2D.global_rotation)
	bullet.velocity = Vector2.RIGHT.rotated(bullet.rotation) * bullet.speed


func _on_fireTimer_timeout():
	canFire = true
