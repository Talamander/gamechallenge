extends KinematicBody2D

var velocity = Vector2.ZERO

export var speed = 600

func _physics_process(delta):
	position += velocity * delta

func _on_Hitbox_body_entered(_body):
	queue_free()


func _on_Hitbox_area_entered(_area):
	queue_free()


func _on_decayTimer_timeout():
	queue_free()
