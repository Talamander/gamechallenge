extends KinematicBody2D

var enemyHealth = 100

const enemyBullet = preload("res://2D Version/Parent Classes/EnemyBullet.tscn")
onready var timer = $ShootTimer
onready var aimRotator = $Rotator

export var rotationSpeed = 200
export var fireRate = 0.25
export var spawnpointCount = 6
export var radius = 75

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
	
	
func _process(delta: float) -> void:
	var new_rotation = aimRotator.rotation_degrees + rotationSpeed * delta
	aimRotator.rotation_degrees = fmod(new_rotation, 360)
	
	


func EnemyTakeDamage(dmg):
	enemyHealth -= dmg
	if enemyHealth <= 0 :
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
