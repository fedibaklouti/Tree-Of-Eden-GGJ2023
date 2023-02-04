extends Area2D


var detected = false 

func _ready():
	$AnimationPlayer.play("fly")
	$idle.play("fly")
	pass 

export (float) var verticalOffset = 0.0

var direction = 1


func die():
	queue_free()
	
	pass
	
var spit = preload("res://Scenes/enemies/spit.tscn")

func spit():
	var newSpit = spit.instance()
	add_child(newSpit)
	newSpit.transform = $Position2D.transform
	pass

func _on_spitter_area_entered(area):
	if area.is_in_group("speardmg"):
		die()
	pass # Replace with function body.



func _on_detectionRange_body_entered(body):
	if body.is_in_group("player"):
		detected=true
		spit()
		$spitTimer.start()
	pass # Replace with function body.


func _on_spitter_body_exited(body):
	if body.is_in_group("player"):
		detected=false 
	pass # Replace with function body.


func _on_spitTimer_timeout():
	spit()
	$spitTimer.start()
	pass # Replace with function body.
