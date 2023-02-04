extends Area2D

var speed = 100
var direction = 1

func _ready():
	pass


func _physics_process(delta):
	position.x += direction * speed  * delta


func _on_spit_body_entered(body):
	queue_free()
	pass # Replace with function body.
