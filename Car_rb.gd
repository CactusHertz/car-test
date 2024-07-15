extends RigidBody3D

var speed := 80
var boost_speed := 160
var steering_factor := 2.0

var gravity_force := 50.0
var local_gravity := Vector3.DOWN
var rotation_speed := 5.0

@onready var ray : RayCast3D = %RayCast3D

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	apply_movement(delta)

func _integrate_forces(state):
	pass

func apply_movement(delta):
	var input_vector := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	
	var movement_velocity = Vector3(0, 0, input_vector.y).normalized() * speed
	transform.basis = Basis(Vector3.UP, -steering_factor * input_vector.x * delta) * transform.basis
	
	apply_central_force(basis * movement_velocity)
	apply_central_force(basis * Vector3.DOWN * gravity_force)

func bounce():
	pass

func orient_car(direction: Vector3, delta: float) -> void: 
	var left_axis := -local_gravity.cross(direction)
	var rotation_basis := Basis(left_axis, -local_gravity, direction).orthonormalized()
	transform.basis = transform.basis.get_rotation_quaternion().slerp(
		rotation_basis, delta * rotation_speed
	)

