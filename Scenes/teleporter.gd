extends Area2D

func _on_teleporter_body_entered(body):
	if body.is_in_group("player"):
		get_tree().change_scene("res://Scenes/parallax test scene.tscn")
	pass # Replace with function body.
