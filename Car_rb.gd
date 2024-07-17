extends RigidBody3D

var speed := 80
var boost_speed := 120
var steering_factor := 0.5 #old 2.0
var steering_tilt := 0.4

var gravity_force := 100.0
var world_gravity := Vector3.DOWN
var local_gravity := Vector3.DOWN
var rotation_speed := 10.0


var is_grounded := false 

@onready var ray : RayCast3D = %RayCast3D
@onready var body : MeshInstance3D = %CarBody
@onready var mph_lable : Label = $UI/mph
@onready var gravity_lable : Label = $UI/gravity
@onready var basis_lable : Label = $UI/basis
@onready var camera_anchor : Node3D = $CameraAnchor

var move_direction := Vector3.ZERO
var last_strong_direction := Vector3.ZERO


func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	pass

# state.step = delta
func _integrate_forces(state):
	apply_movement(state)
	update_ui()

func apply_movement(state : PhysicsDirectBodyState3D):
	if move_direction.length() > 0.1:
		last_strong_direction = move_direction.normalized()
	move_direction = get_model_oriented_input()
	orient_car(last_strong_direction, state.step)
	

	
	var input_vector := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var movement_velocity = Vector3(0, 0, input_vector.y).normalized() * speed
	#transform.basis = Basis(Vector3.UP, -steering_factor * input_vector.x * state.step) * transform.basis
	tilt_body(state.step,input_vector)
	apply_central_force(basis * movement_velocity)
	apply_central_force(basis * Vector3.DOWN * gravity_force)
	


func get_model_oriented_input() -> Vector3:
	var raw_input = -Input.get_vector("move_left", "move_right", "move_forward", "move_back").normalized()
	
	var input := Vector3.ZERO
	input.x = raw_input.x * steering_factor
	input.z = abs(raw_input.y) 
	
	return basis * input

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
	#camera_anchor.transform.basis = Basis(new_rot)
	
	

func orient_car(direction: Vector3, delta: float) -> void: 
	if ray.is_colliding():
		local_gravity = -ray.get_collision_normal()
	else:
		local_gravity = world_gravity
	
	
	
	var left_axis := -local_gravity.cross(direction)
	var rotation_basis := Basis(left_axis, -local_gravity, direction).orthonormalized()
	basis = basis.get_rotation_quaternion().slerp(
		rotation_basis, delta * rotation_speed
	)

func update_ui():
	mph_lable.text = "linear velocity: " + str(linear_velocity.length())
	gravity_lable.text = "world gravity: " + str(world_gravity) + " local gravity: " + str(local_gravity) 
	basis_lable.text = "basis: " + str(basis) + " transform basis: " + str(transform.basis)
