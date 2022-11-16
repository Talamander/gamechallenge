extends KinematicBody2D

var velocity = Vector2.ZERO

export var speed = 600

func _physics_process(delta):
	var collision_info = move_and_collide(velocity.normalized() * delta * speed )



func _on_Hitbox_body_entered(_body):
	#queue_free()
	pass

func _on_Hitbox_area_entered(_area):
	#queue_free()
	pass


func _on_decayTimer_timeout():
	#queue_free()
	pass



func _on_Area2D_body_entered(body):
	if body.has_method("EnemyTakeDamage"):
		body.EnemyTakeDamage(10)
		#queue_free()
