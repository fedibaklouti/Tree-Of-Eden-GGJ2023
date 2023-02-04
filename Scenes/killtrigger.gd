extends Area2D


func _ready():
	pass 


func _on_killtrigger_body_entered(body):
	if body.is_in_group("player"):
		get_tree().reload_current_scene()
	pass # Replace with function body.
