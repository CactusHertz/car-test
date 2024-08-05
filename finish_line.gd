extends Area3D



func _on_body_entered(body):
	if body.is_in_group("car"):
		if body.num_checkpoints ==  body.checkpoints.size():
			body.curr_lap +=1
			body.checkpoints.clear()
