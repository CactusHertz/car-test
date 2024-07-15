extends RigidBody3D

var speed := 80
var steering_factor := 2.0

var gravity_force := 50.0

func _ready() -> void:
	pass



func _physics_process(delta: float) -> void:
	
	var input_vector := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	
	var movement_velocity = Vector3(0, 0, input_vector.y).normalized() * speed
	
	#rotation.y += - input_vector.x * steering_factor * delta
	
	transform.basis = Basis(Vector3.UP, -steering_factor * input_vector.x * delta) * transform.basis
	
	apply_central_force(basis * movement_velocity)
	apply_central_force(basis * Vector3.DOWN * gravity_force)

