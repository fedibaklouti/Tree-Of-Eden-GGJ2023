extends Area2D


export var path = "res://Scenes/parallax test scene.tscn"

func _on_teleporter_body_entered(body):
	if body.is_in_group("player"):
		$AnimationPlayer.play("fadeout")
	pass # Replace with function body.


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "fadeout":
		get_tree().change_scene("res://Scenes/parallax test scene.tscn")
	pass # Replace with function body.
