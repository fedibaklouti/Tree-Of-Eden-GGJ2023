extends StaticBody2D

export var leafDirection = 1
var playerisontop = false

func _ready():
	pass

func _physics_process(delta):
	if playerisontop:
		rotation_degrees+= leafDirection * 0.75
		rotation_degrees=clamp(rotation_degrees,-90,90) 
	else:
		rotation_degrees=lerp(rotation_degrees, 0, 0.01)


func _on_leafArea_body_exited(body):
	if body.is_in_group("player"):
		playerisontop=false



func _on_leafArea_body_entered(body):
	if body.is_in_group("player"):
		playerisontop=true
		
