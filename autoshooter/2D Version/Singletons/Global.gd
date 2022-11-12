extends Node

# Singletons are globally accessible and can be great for sharing functions
# across several scripts
# we are using this singleton for the instancing scenes within scenes 
# basically
# bullets, effects, etc

func instance_scene_on_main(scene, position):
	var main = get_tree().current_scene
	var instance = scene.instance()
	main.add_child(instance)
	instance.global_position = position
	return instance
