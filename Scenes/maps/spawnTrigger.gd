extends Area2D


func _ready():
	pass


func _on_SpawnTrigger_body_entered(body):
	body.position.x = 24
	pass # Replace with function body.
