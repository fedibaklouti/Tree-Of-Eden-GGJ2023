extends Area2D


func _ready():
	$AnimationPlayer.play("fly")
	$idle.play("fly")
	pass 

export (float) var verticalOffset = 0.0

func _physics_process(delta):
	position.x += 100 * delta
	position.y += verticalOffset

