extends KinematicBody2D

var velocity = Vector2.ZERO

export var damage = 10
export var speed = 100

func _physics_process(delta):
	position += transform.x * speed * delta
	
		

func _on_decayTimer_timeout():
	queue_free()


func _on_Area2D_body_entered(body):
	if body.has_method("TakeDamage"):
		body.TakeDamage(damage)
		queue_free()
