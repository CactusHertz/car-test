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
		
		#align_to_normal(delta)
	

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
	
	print(normal)
	
	var target_up = get_collision_normal()
	var current_up = global_transform.basis.y
	var rotation_to_target = current_up.cross(target_up).normalized()
	var angle_to_target = acos(current_up.dot(target_up))
	var rotation_delta = rotation_to_target * angle_to_target * delta * 10
	car.angular_velocity = car.angular_velocity.lerp(rotation_delta, 0.1)
	#var rotation_axis = Vector3.UP.cross(normal).normalized()
	#var rotation_angle = Vector3.UP.angle_to(normal)
	#car.transform.basis = Basis(rotation_axis, rotation_angle)

	'''
	var forward = transform.basis.z
	var right = normal.cross(forward).normalized()
	var up = -right.cross(forward).normalized()
	car.transform.basis = Basis(right, up, forward)
	
	print(car.transform.basis, Basis(right, up, forward))'''

