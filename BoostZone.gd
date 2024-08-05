extends Area3D


func _on_body_entered(body):
	if body.is_in_group("car"):
		print("in_boost")
		body.start_boost()


func _on_body_exited(body):
	if body.is_in_group("car"):
		body.end_boost()
