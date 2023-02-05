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

var explosion = preload("res://Scenes/enemies/enemydeath.tscn").instance()

func die():
	$"..".add_child(explosion)
	explosion.transform = transform
	queue_free()

func _on_flyingMonster_area_entered(area):
	if area.is_in_group("whipdmg"):
		die()
	pass # Replace with function body.


func _on_VisibilityNotifier2D_screen_exited():
	direction = -direction
	$Sprite.set_flip_h(direction != -1)
	pass # Replace with function body.
