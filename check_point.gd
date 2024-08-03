extends Area3D

@onready var spawn_point = $SpawnPoint


func _on_body_entered(body):
	if body.is_in_group("car"):
		body.spawn_location = spawn_point.global_transform



func _on_body_exited(body):
	pass # Replace with function body.

