extends RigidBody3D

var speed := 40
var steering_factor := 3.0

var gravity_force := 9.0

func _ready() -> void:
	pass



func _physics_process(delta: float) -> void:
	
	var input_vector := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	
	var movement_velocity = Vector3(0, 0, input_vector.y).normalized() * speed
	
	rotation.y += - input_vector.x * steering_factor * delta
	
	apply_central_force(basis * movement_velocity)
	apply_central_force(basis* Vector3.DOWN * gravity_force)

