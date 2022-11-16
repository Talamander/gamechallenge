extends KinematicBody2D

#This script controls everything to do with the player: movement, firing, targeting, anim

#Preloads
const playerBullet = preload("res://2D Version/Parent Classes/Projectile.tscn")

#Exports
export var rotation_speed:= 90.0
export var gunCount = 6

#Onready Variables
onready var animPlayer = $AnimationPlayer
onready var fireTimer = $fireTimer
onready var holster = $bullet
onready var bulletSpawn = $BulletSpawn

#debugui
onready var healthLabel = $HealthLabel


#Movement Variables
var motion = Vector2.ZERO
var acceleration:= 5000
var speed:= 360.0


#Combat Variables
var playerHealth = 100
var playerHealthMAX = 100

var canFire = true

var fireRate := 0.3
var lastFire := 0.00




#Firing Call
func _input(ev):
	if Input.is_action_pressed("weapon_fire"):
		fire_bullet()



func _physics_process(delta: float) -> void:
	
	if playerHealth <= 0:
		animPlayer.play("Dead")
		return
	
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
	lastFire += delta
	
	#Regeneration
	if playerHealth < playerHealthMAX and playerHealth > 0:
		playerHealth += 0.01;
		healthLabel.text = "HP: " + String(playerHealth)
	

#Animation System
func animHandler():
	
	var look_dir = get_global_mouse_position() - global_position
	
	if look_dir.x > 0:
		$Sprite.set_flip_h(false)
		$shadow.set_flip_h(false)
	elif look_dir.x < 0:
		$Sprite.set_flip_h(true)
		$shadow.set_flip_h(true)
		
	
	if motion == Vector2.ZERO:
		animPlayer.play("Idlke")



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
	


func TakeDamage(dmg):
	playerHealth -= dmg
	
	if playerHealth <= 0:
		print("You died")
		healthLabel.text = "Game Over"
		animPlayer.play("Dead")
		return
		
	print("player hit HP: " + String(playerHealth))
	healthLabel.text = "HP: " + String(playerHealth)


#Firing System Updated
func fire_bullet():
	if lastFire >= fireRate :
		for i in range(gunCount):
			var bullet = playerBullet.instance()
			get_parent().add_child(bullet)
			var newvec = Vector2(bulletSpawn.global_position.x+35, bulletSpawn.global_position.y+25)
			bullet.position = newvec
			bullet.look_at(get_global_mouse_position())
			bullet.velocity = get_global_mouse_position() - bullet.position
			motion -= bullet.velocity*.5
			SoundManager.play("Bullet", rand_range(0.8, 1.3), 0)
		lastFire = 0
	return


func _on_fireTimer_timeout():
	canFire = true
