extends Node2D

func _ready():
	var localPlayer = get_node("Player")
	
	Global.player = localPlayer
	
	Music.list_play()
