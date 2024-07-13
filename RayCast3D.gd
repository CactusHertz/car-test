extends RayCast3D

@onready var car : RigidBody3D = get_parent()

@export var ride_height := -9.0
@export var ride_spring_damper := 10.0
@export var ride_spring_strength := 50.0



func _ready():
	pass

func _physics_process(delta):
	if is_colliding():
		apply_spring_force(delta)
		
		align_to_normal(delta)
	

func apply_spring_force(delta):
	var vel = car.linear_velocity 
	var ray_dir := global_basis.y
	
	var other_vel := Vector3.ZERO
	
	var ray_dir_vel = vel.dot(ray_dir)
	
	var rel_vel = ray_dir_vel 
	
	var distance = -get_collision_point().distance_to(global_position)
	var x = distance - ride_height
	
	var spring_force = (x * ride_spring_strength) - (rel_vel * ride_spring_damper)
	
	car.apply_central_force(ray_dir * spring_force)

func align_to_normal(delta):
	var normal := get_collision_normal()
	
	var up := Vector3(0,1,0)
	
	var target_rotation = up.cross(normal).normalized()
	
	# print(target_rotation)
	# var target_quat = Quat(up, normal).slerp(basis.get_rotation_quat(), 0.1)
