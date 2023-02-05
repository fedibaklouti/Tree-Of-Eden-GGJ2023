extends Node2D

func start_game():
	get_tree().change_scene("res://Scenes/cavescene.tscn")
	
func _input(event):
	if Input.is_action_just_pressed("move_jump"):
		start_game()
		
		


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "intro":
		start_game()
