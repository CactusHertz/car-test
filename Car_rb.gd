extends RigidBody3D

var speed := 80
var boost_speed := 120
var steering_factor := 2.0
var steering_tilt := 0.5

var gravity_force := 50.0
var local_gravity := Vector3.DOWN
var rotation_speed := 5.0


var is_grounded := false 

@onready var ray : RayCast3D = %RayCast3D
@onready var body : MeshInstance3D = %CarBody

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	apply_movement(delta)

func _integrate_forces(state):
	pass

func apply_movement(delta: float):
	var input_vector := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	
	var movement_velocity = Vector3(0, 0, input_vector.y).normalized() * speed
	transform.basis = Basis(Vector3.UP, -steering_factor * input_vector.x * delta) * transform.basis
	tilt_body(delta,input_vector)
	
	apply_central_force(basis * movement_velocity)
	apply_central_force(basis * Vector3.DOWN * gravity_force)

func bounce():
	pass

func tilt_body( delta: float, input_vector: Vector2):
	var home_tilt := Quaternion()
	var desired_tilt := Quaternion(Vector3(0,0,1), -input_vector.x * steering_tilt)
	
	var target_rotation = desired_tilt
	var slerp_speed = 5.0
	
	var current_rot = Quaternion(body.transform.basis)
	var new_rot = current_rot.slerp(target_rotation, delta* slerp_speed)
	body.transform.basis = Basis(new_rot)
	
	

func orient_car(direction: Vector3, delta: float) -> void: 
	var left_axis := -local_gravity.cross(direction)
	var rotation_basis := Basis(left_axis, -local_gravity, direction).orthonormalized()
	transform.basis = transform.basis.get_rotation_quaternion().slerp(
		rotation_basis, delta * rotation_speed
	)

