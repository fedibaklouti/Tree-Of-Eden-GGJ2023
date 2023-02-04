extends KinematicBody2D

var JUMPHEIGHT = 350
var GRAVITY = 1000
var velocity = Vector2.ZERO
var UP = Vector2.UP
const maxSpeed = 180
const accel = 0.4
const decel = 0.25
var dir = 0

enum Player_States {IS_IDLE = 0, IS_RUNNING=1, IS_JUMPING=2}
enum Player_Actions {NOTHING = 0, IS_WHIPPING = 1, IS_SPEARING=2, IS_PLANTING=3, IS_DAMAGED=4}

var PlayerState = Player_States.IS_IDLE
var PlayerAction = Player_Actions.NOTHING

var camZoom = 1
var camZoomSpeed = 0.1
var zoom = camZoom

const maxHealth = 3
var health = maxHealth 
var alive = true
var isInvulnurable = false
var canPlant = true



var animationsList = [
	{"type": "normal",
	"idle": "idle",
	"jump":"jump",
	"walk":"walking",
	"fall":"fall"
	},
	{"type": "spear",
	"idle": "idle_spear",
	"jump":"jump_spear",
	"walk":"walking_spear",
	"fall":"fall_spear"
	},
	{"type": "whip",
	"idle": "idle_whip",
	"jump":"jump_whip",
	"walk":"walking_whip",
	"fall":"fall_whip"
	}
]

var currentEquippedWeapon = 0


var inventory = [
	{
		"type": "mushroom",
		"ammo": 0,
		"instance": preload("res://Scenes/gimmicks/mushroom.tscn"),
		"offset": -12
	},
	{
		"type": "leaf",
		"ammo": 0,
		"instance": preload("res://Scenes/gimmicks/leaf.tscn"),
		"offset": -10
	},
	{
		"type":"flower",
		"ammo": 0,
		"instance": preload("res://Scenes/gimmicks/flower.tscn")
	}
]

var equipped = inventory[0]

var treeMaterial = load("res://Scenes/TreeShader.tres")
var treebarkcylinder = load("res://Scenes/treebarkcylinder.tscn")

onready var Animator = $AnimationPlayer

func _ready():
	pass
	

onready var floorcast = $raycasts/floorcast
onready  var playersprite = $Sprite

func setEquipped(index):
	equipped = inventory[index]
	print("equipped ", equipped)
	
func plant():
	if floorcast.is_colliding() && canPlant:
		canPlant = false 
		var currnetTransform = transform
		currentEquippedWeapon = 0
		PlayerAction = Player_Actions.IS_PLANTING
		var plant_instance = equipped.instance.instance()
		$"..".add_child(plant_instance)
		Animator.play("plant")
		yield(get_tree().create_timer(0.5), "timeout")
		plant_instance.transform = currnetTransform
		plant_instance.scale = Vector2(0,0)
		plant_instance.animator.play("spawn")
	pass
	

func playSound(sound):
	match sound:
		"whip":
			$playersfx.stream=preload("res://Audio/sfx/whip_crack.wav")
			$playersfx.play()
		"health":
			$guisound.stream=preload("res://Audio/sfx/hp1.ogg")
			$guisound.play()
			pass
		"spear":

			$playersfx.stream=preload("res://Audio/sfx/punch2.ogg")
			$playersfx.play()
		"boing":
			
			$playersfx.stream=preload("res://Audio/sfx/pluck.ogg")
			$playersfx.play()

func _input(event):
	if alive:
		if Input.is_action_just_pressed("equip_mushroom"):
			setEquipped(0)
		if Input.is_action_just_pressed("equip_leaf"):
			setEquipped(1)
		if Input.is_action_just_pressed("equip_flower"):
			setEquipped(2)
		if Input.is_action_just_pressed("spear_attack"):
			spearAttack()
		if Input.is_action_just_pressed("whip_attack"):
			whip()
		if Input.is_action_just_pressed("action_plant"):
			plant()
		
func whip():
	currentEquippedWeapon= 2
	PlayerAction = Player_Actions.IS_WHIPPING
	Animator.play("whip_attack")
	pass
	
func spearAttack():
	currentEquippedWeapon= 1
	PlayerAction = Player_Actions.IS_SPEARING
	Animator.play("spear_attack")
	pass 


func bounce():

	var currentVelocity = velocity.y
	velocity.y = -currentVelocity*1.45
	playSound("boing")
	pass


func getHit():
	if !isInvulnurable:
		health -= 1
		PlayerAction = Player_Actions.IS_DAMAGED
		isInvulnurable=true
		if health > 0:
			Animator.play("damaged")
			$invulplayer.play("invulframes")
			yield(get_tree().create_timer(2), "timeout")
			isInvulnurable=false
			$invulplayer.stop()
			modulate.a = 1
	
func jump():
	if is_on_floor():
		velocity.y -= JUMPHEIGHT
		PlayerState = Player_States.IS_JUMPING
	pass
	
func damageTracker():
	if !isInvulnurable:
		if $raycasts/hazardfloorcast.is_colliding():
			getHit()
			velocity.x += 400*dir
			velocity.y -= 200
		if $raycasts/frontcast.is_colliding():
			getHit()
			velocity.x -= 400
			if is_on_floor():
				velocity.y -= 200
		elif $raycasts/backcast.is_colliding():
			getHit()
			velocity.x += 400
			if is_on_floor():
				velocity.y -= 200
	
	
	pass

var playedDeathAnim = false 
	
func AnimationManager():

	if alive: 
		if PlayerAction == Player_Actions.NOTHING:
			if !is_on_floor():
				if (velocity.y < -100):
					Animator.play(animationsList[currentEquippedWeapon].jump)
				elif (velocity.y > 200):
					Animator.play(animationsList[currentEquippedWeapon].fall)
			match PlayerState:
				Player_States.IS_IDLE:
					if is_on_floor():
						Animator.play(animationsList[currentEquippedWeapon].idle)
				Player_States.IS_RUNNING:
					if is_on_floor():
						Animator.play(animationsList[currentEquippedWeapon].walk)
	else:
		if !playedDeathAnim:
			Animator.play("dead")
		
	
	pass

func playerControls():
	if PlayerAction != Player_Actions.IS_PLANTING:
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
	else:
		velocity.x = 0
	
func death():
	
	pass
	
var treeUVSpeed = 0
	
func _physics_process(delta):
	if (PlayerAction != Player_Actions.IS_SPEARING && PlayerAction != Player_Actions.IS_WHIPPING) && $Sprite2.is_visible():
		#yield(get_tree().create_timer(0.2),"timeout")
		$Sprite2.hide()
	AnimationManager()
	if (zoom != camZoom):
		zoom = lerp(zoom, camZoom, camZoomSpeed)
		$Camera2D.zoom=Vector2(zoom,zoom)
	
	alive = health > 0
	velocity.y += GRAVITY * delta
	velocity.y = clamp(velocity.y, -1500, 1500)
	if is_on_floor():
		var normal: Vector2 = get_floor_normal()
		playersprite.rotation = lerp(playersprite.rotation, normal.angle() + deg2rad(90), 0.3)
	else: 
		playersprite.rotation = lerp(playersprite.rotation, 0, 0.3)
	if alive:

		if dir != 0:
			$attackhitbox/spearAttackHitbox.position.x = 32 * dir
			$attackhitbox/whipAttackHitbox.position.x = 32 * dir
			$Sprite2.position.x = 32*dir
			$Sprite2.flip_h=dir != 1
		damageTracker()
		if dir == 0:
			treeUVSpeed = lerp(treeUVSpeed, 0, 0.8)
		else:
			treeUVSpeed = dir * 4
		if PlayerState == Player_States.IS_RUNNING:
			if !is_on_floor():
				treeMaterial.set_shader_param("motion", velocity)
			else:
				treeMaterial.set_shader_param("motion", Vector2(velocity.x, 0))
		else:
			if !is_on_floor() && abs(velocity.y) > 100:
				treeMaterial.set_shader_param("motion", Vector2(0, velocity.y))
			else: 
				treeMaterial.set_shader_param("motion", Vector2(0, 0))
		health = clamp(health, 0, maxHealth)
		playerControls()
		if PlayerState == Player_States.IS_RUNNING:
			playersprite.set_flip_h(dir != 1)
	else: 
		camZoom = 0.6
		velocity.x = 0
		death()
		if !is_on_floor():
			treeMaterial.set_shader_param("motion", Vector2(0, velocity.y))
		else:
			treeMaterial.set_shader_param("motion", Vector2(0, 0))
	velocity = move_and_slide(velocity, UP, true, 4)


func _on_zoom_trigger_body_entered(body, extra_arg_0):
	if body.is_in_group("player"):
		camZoomSpeed = 0.005
		camZoom = extra_arg_0
	pass # Replace with function body.


func _on_zoom_trigger_body_exited(body):
	if body.is_in_group("player"):
		camZoom= 1
	pass # Replace with function body.



func setAbleToPlant(cond):
	canPlant = cond


func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		"spear_attack":
			PlayerAction = Player_Actions.NOTHING
		"whip_attack":
			PlayerAction = Player_Actions.NOTHING
		"dead":
			playedDeathAnim= true
			yield(get_tree().create_timer(3), "timeout")
			get_tree().reload_current_scene()
		"plant":
			PlayerAction = Player_Actions.NOTHING
		"damaged":
			PlayerAction = Player_Actions.NOTHING
	pass # Replace with function body.


func _on_Hitbox_body_entered(body):
	if body.is_in_group("enemy"):
		print("IM DYING")
		body.die()
	pass # Replace with function body.
