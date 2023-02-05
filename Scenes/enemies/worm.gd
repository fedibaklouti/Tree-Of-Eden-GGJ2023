extends KinematicBody2D

var GRAVITY = 500
var velocity = Vector2.ZERO
var UP = Vector2.UP

var dir = -1

onready var frontcast = $casts/frontcast
onready var backcast = $casts/backcast
onready var bottomcastfront = $casts/bottomcastfront
onready var bottomcastback = $casts/bottomcastback


var chasing = false 
var speed = 50

func checkDirection ():
	if ($casts/playerfrontCast.is_colliding() && speed != 180):
		speed = 180
		chasing=true
	elif (!$casts/playerfrontCast.is_colliding() && speed != 50):
		speed = 50
		chasing=false

	if (!bottomcastfront.is_colliding() || frontcast.is_colliding()) && dir != -1:
		if !chasing:
			dir = 0
			yield(get_tree().create_timer(0.8), "timeout")
		dir = -1
		$casts/playerfrontCast.set_cast_to(Vector2(-150, 0))
		$Sprite.set_flip_h(true)

	elif (!bottomcastback.is_colliding() || backcast.is_colliding()) && dir != 1:
		if !chasing:
			dir = 0
			yield(get_tree().create_timer(0.8), "timeout")
		dir = 1
		$casts/playerfrontCast.set_cast_to(Vector2(150, 0))
		$Sprite.set_flip_h(false)

	pass

func _ready():
	checkDirection()
	$idle.play("fly")
	pass 

var explosion = preload("res://Scenes/enemies/enemydeath.tscn").instance()

func die():
	$"..".add_child(explosion)
	explosion.transform = transform
	queue_free()

func _physics_process(delta):
	checkDirection()
	velocity.x = dir*speed
	velocity.y += GRAVITY * delta
	velocity = move_and_slide(velocity, UP, true, 4)


func _on_whipdetector_area_entered(area):
	if area.is_in_group("whipdmg"):
		velocity.y -= 200
	pass # Replace with function body.
