extends RayCast3D

@onready var car : RigidBody3D = get_parent()

@export var ride_height := -9.0
@export var ride_spring_damper := 10.0
@export var ride_spring_strength := 100.0

func _physics_process(delta):
	if is_colliding():
		apply_spring_force()

func apply_spring_force():
	var vel = car.linear_velocity 
	var ray_dir := global_basis.y
	
	var ray_dir_vel = vel.dot(ray_dir)
	var rel_vel = ray_dir_vel 
	
	var distance = -get_collision_point().distance_to(global_position)
	var x = distance - ride_height
	
	var spring_force = (x * ride_spring_strength) - (rel_vel * ride_spring_damper)
	car.apply_central_force(ray_dir * spring_force)


