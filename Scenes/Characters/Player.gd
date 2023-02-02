extends KinematicBody2D

var JUMPHEIGHT = 500
var GRAVITY = 1000
var velocity = Vector2.ZERO
var UP = Vector2.UP
const maxSpeed = 200
const accel = 0.4
const decel = 0.25
var dir = 0

enum Player_States {IS_IDLE = 0, IS_RUNNING=1, IS_JUMPING=2}
enum Player_Actions {NOTHING = 0, IS_WHIPPING = 1, IS_SWINGING=2}

var PlayerState = Player_States.IS_IDLE
var PlayerAction = Player_Actions.NOTHING

const maxHealth = 3
var health = maxHealth 
var alive = true
var isInvulnurable = false

var treeMaterial = load("res://Scenes/TreeShader.tres")

func _ready():
	pass
	
	
func whip():
	print("Whipping")
	
	pass
	
func spearAttack():
	print("Spearing")
	
	pass 

func getHit():
	if !isInvulnurable:
		health -= 1
		isInvulnurable=true
		yield(get_tree().create_timer(1), "timeout")
		isInvulnurable=false
	
func jump():
	if is_on_floor():
		velocity.y -= JUMPHEIGHT
	pass

func playerControls():
	dir = 0
	PlayerState = Player_States.IS_IDLE
	if Input.is_action_just_pressed("move_jump"):
		jump()
	if Input.is_action_pressed("move_left"):
		dir = -1
		PlayerState = Player_States.IS_RUNNING
	elif Input.is_action_pressed("move_right"):
		dir = 1
		PlayerState = Player_States.IS_RUNNING
	if dir != 0:
		velocity.x = lerp(velocity.x, maxSpeed*dir, accel)
	else:
		velocity.x = lerp(velocity.x, 0, decel)
	pass
	
func death():
	
	pass
	
var treeUVSpeed = 0
	
func _physics_process(delta):
	alive = health > 0
	if alive:
		if dir == 0:
			treeUVSpeed = lerp(treeUVSpeed, 0, 0.8)
		else:
			treeUVSpeed = dir * 4
		if PlayerState == Player_States.IS_RUNNING:
			treeMaterial.set_shader_param("motion", velocity)
		else:
			treeMaterial.set_shader_param("motion", Vector2(0, velocity.y))
		velocity.y = clamp(velocity.y, -1500, 1500)
		velocity.y += GRAVITY * delta
		health = clamp(health, 0, maxHealth)
		playerControls()
		velocity = move_and_slide(velocity, UP, true, 4)
	else: 
		death()