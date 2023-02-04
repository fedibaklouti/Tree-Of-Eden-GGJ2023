extends KinematicBody2D

var JUMPHEIGHT = 500
var GRAVITY = 500
var velocity = Vector2.ZERO
var UP = Vector2.UP
const maxSpeed = 400
const accel = 0.4
const decel = 0.25
var dir = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass 

	
func jump():
	if $"../Player".is_on_floor():
		velocity.y += JUMPHEIGHT
	pass
	

func playerControls():
	dir = 0

	if Input.is_action_just_pressed("move_jump"):
		jump()
	if Input.is_action_pressed("move_left"):
		dir = -1

	elif Input.is_action_pressed("move_right"):
		dir = 1

	if dir != 0:
		velocity.x = -lerp(velocity.x, maxSpeed*dir, accel)
	else:
		velocity.x = lerp(velocity.x, 0, decel)
	pass
		

func _physics_process(delta):
	playerControls()
	velocity.y = clamp(velocity.y, -1500, 1500)
	if $"../Player".is_on_wall():
		velocity.x = 0
	if !$"../Player".is_on_floor():
		velocity.y -= GRAVITY * delta
	velocity = move_and_slide(velocity, UP, true, 4)
