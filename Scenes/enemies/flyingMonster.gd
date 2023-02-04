extends Area2D


func _ready():
	$AnimationPlayer.play("fly")
	$idle.play("fly")
	pass 

export (float) var verticalOffset = 0.0

var direction = 1

func _physics_process(delta):
	position.x += 100 * delta * direction
	position.y += verticalOffset


func die():
	queue_free()
	
	pass


func _on_flyingMonster_area_entered(area):
	if area.is_in_group("damage"):
		die()
	pass # Replace with function body.


func _on_VisibilityNotifier2D_screen_exited():
	direction = -direction
	$Sprite.set_flip_h(direction != -1)
	pass # Replace with function body.
