extends RigidBody3D


var speed := 120.0#80
var boost_speed := 240.0
var max_speed := speed
var steering_factor := 0.2 #old 2.0
var steering_tilt := 0.4

var gravity_force := 100.0
var world_gravity := Vector3.DOWN
var local_gravity := Vector3.DOWN
var rotation_speed := 10.0


var is_grounded := false 

@onready var ray : RayCast3D = %RayCast3D
@onready var body : MeshInstance3D = %CarBody
@onready var camera_anchor : Node3D = $CameraAnchor

@onready var mph_lable : Label = $UI/mph
@onready var gravity_lable : Label = $UI/gravity
@onready var basis_lable : Label = $UI/basis

var move_direction := Vector3.ZERO
var last_strong_direction := Vector3.BACK

var curr_direction := Vector3.BACK
var target_direction := Vector3.BACK

var spawn_location : Transform3D
var max_depth := -30.0
var last_check_point := spawn_location

func _ready() -> void:
	spawn_location = transform

func _process(delta) -> void:
	if position.y < max_depth or Input.is_action_just_pressed("respawn"):
		respawn()


func respawn() -> void:
	transform = spawn_location
	linear_velocity = Vector3.ZERO

# state.step = delta
func _integrate_forces(state) -> void:
	
	if Input.is_action_just_pressed("boost"):
		max_speed = boost_speed
		get_node("Timer").start()
		
		
	apply_movement(state)
	update_ui()

func apply_movement(state : PhysicsDirectBodyState3D):
	
	var input_vector := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var movement_velocity = Vector3(0, 0, input_vector.y).normalized() * max_speed

	tilt_body(state.step,input_vector)
	apply_central_force(basis * movement_velocity)
	apply_central_force(basis * Vector3.DOWN * gravity_force)
	
	var input = get_model_oriented_input().normalized()
	var slerp_speed = 2.0
	curr_direction = curr_direction.slerp(input, state.step * slerp_speed)
	
	orient_car(basis * curr_direction, state.step)


func get_model_oriented_input() -> Vector3:
	var raw_input = -Input.get_axis("move_left", "move_right")
	
	var input := Vector3.ZERO
	input.x = raw_input * steering_factor
	input.z = 1.0
	
	return input

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

func bounce():
	pass

func tilt_body( delta: float, input_vector: Vector2):
	var desired_tilt := Quaternion(Vector3(0,0,1), -input_vector.x * steering_tilt)

	var slerp_speed = 2.0
	var current_rot = Quaternion(body.transform.basis)
	var new_rot = current_rot.slerp(desired_tilt, delta* slerp_speed)
	body.transform.basis = Basis(new_rot)
	camera_anchor.transform.basis = Basis(new_rot) 


func update_ui():
	mph_lable.text = "linear velocity: " + str(linear_velocity.length())
	gravity_lable.text = "world gravity: " + str(world_gravity) + " local gravity: " + str(local_gravity) 
	basis_lable.text = "basis: " + str(basis)


func _on_timer_timeout():
	max_speed = speed
