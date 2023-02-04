extends StaticBody2D

enum gimmickTypes {MUSHROOM = 0, LEAF= 1, FLOWER=2 }

export (gimmickTypes) var gimmickType 

func _ready():
	$AnimationPlayer.play("spawn")
	pass 

var bounceCount = 0


func _on_Mushroom_body_entered(body):
	if body.is_in_group("player"):
		if gimmickType == gimmickTypes.MUSHROOM && body.velocity.y > 0:
			body.bounce()
			$AnimationPlayer.play("bounce")
			bounceCount += 1
			if bounceCount > 2:
				$AnimationPlayer.play_backwards("spawn")
				yield(get_tree().create_timer(0.5),"timeout")
				call_deferred("queue_free")
	pass # Replace with function body.
	

func _physics_process(delta):
	if gimmickType == gimmickTypes.FLOWER:
		position.y -= 20 * delta 
		pass


func _on_Timer_timeout():
	call_deferred("queue_free")
	pass # Replace with function body.
