extends KinematicBody2D

const enemyBullet = preload("res://2D Version/Enemies/EnemyFireBall.tscn")
const explosion = preload("res://2D Version/Effects/ExplosionEffect.tscn")
onready var timer = $ShootTimer
onready var aimRotator = $Rotator

var rotationSpeed = 1000
var fireRate = 1.5
var spawnpointCount = 5
var radius = 75

#Movement Variables
var motion = Vector2.ZERO
var acceleration:= 5000
var speed:= 25

export var enemyHealth = 30


func _ready():
	var step = 2* PI/ spawnpointCount
	
	for i in range(spawnpointCount):
		var spawn_point = Node2D.new()
		var pos = Vector2(radius, 0).rotated(step * i)
		spawn_point.position = pos
		spawn_point.rotation = pos.angle()
		aimRotator.add_child(spawn_point)
		
	timer.wait_time = fireRate
	timer.start()
	
	
func _physics_process(delta: float) -> void:
	
	handle_rotation(delta)
	chase_player(delta)

func chase_player(delta):
	var direction = (Global.player.global_position - global_position).normalized()
	#if check_the_distance() > chaseLength:
	motion += direction * acceleration * delta
	motion = motion.clamped(speed)
	#previousMotion = motion
	motion = move_and_slide(motion)
	
	#rotation = direction.angle()


func check_distance_to_player():
	var distance = self.position.distance_to(Global.player.position)
	return distance

func handle_rotation(delta):
	var new_rotation = aimRotator.rotation_degrees + rotationSpeed * delta
	aimRotator.rotation_degrees = fmod(new_rotation, 360)

func EnemyTakeDamage(dmg):
	enemyHealth -= dmg
	if enemyHealth <= 0 :
		Global.instance_scene_on_main(explosion, self.global_position)
		queue_free()
	print("Enemy Hit")

func _on_ShootTimer_timeout():
	for s in aimRotator.get_children():
		var bullet = enemyBullet.instance()
		var root = get_tree().get_root()
		var current_scene = root.get_child(root.get_child_count()-1)
		current_scene.add_child(bullet)
		bullet.position = s.global_position
		bullet.rotation = s.global_rotation
