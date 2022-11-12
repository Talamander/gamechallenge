extends Position2D

var max_ray_distance = 250
var angle_between_rays = deg2rad(5.0)


var target_list = []
var ray_list = []
var active = false


func _physics_process(delta):
	
	#DEBUG
	if Input.is_action_just_pressed("ui_accept"):
		print("Rays: ", ray_list)
		var delete = ray_list.pop_back()
		delete.enabled = false
	
	
	
	update_raycasts()
	
	for i in ray_list:
		if i.is_colliding():
			#DEBUG
			#print("This ray is colliding: ", i)
			return


#Generating the raycasts via code
func generate_raycasts(amount: int) -> void:
	
	for i in amount:
		var ray = RayCast2D.new()
		
		var angle = deg2rad(90)
		ray.cast_to = Vector2.UP.rotated(angle) * max_ray_distance
		add_child(ray)
		ray.enabled = true #I think we can somehow use if it's enabled/disabled to track which ones are in use
		ray_list.append(ray)
		#ray.set_collision_mask_bit(2)
	
	#DEBUG
	print("Generated: ", amount, " raycasts!")

func update_raycasts():
	pass

func aim_raycasts():
	#aim raycast at closest free enemy
	var target = get_closest_enemy() #that isn't targeted
	var raycast = get_raycast() #that isn't actively targeting
	
	raycast.target = target
	
	#DEBUG
	print(raycast)

func get_raycast():
	for i in ray_list:
		if i.enabled != true:
			return i


func get_closest_enemy() -> KinematicBody2D:
	var close_boi = null
	for target in target_list:
		if close_boi == null:
			close_boi = target
		elif self.position.distance_to(target.position) < self.position.distance_to(close_boi.position):
			close_boi = target
	return close_boi



func _on_Area2D_body_entered(body):
	if body.is_in_group("enemy"):
		target_list.append(body)
		active = true #just a check


func _on_Area2D_body_exited(body):
	if body.is_in_group("enemy"):
		target_list.erase(body)
