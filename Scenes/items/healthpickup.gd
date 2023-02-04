extends Area2D


func _ready():
	pass # Replace with function body.





func _on_healthpickup_body_entered(body):
	if body.is_in_group("player"):
		body.health = 3
		queue_free()
	pass # Replace with function body.
