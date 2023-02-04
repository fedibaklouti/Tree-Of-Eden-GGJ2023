extends Control

export (NodePath) var PlayerNode

onready var Player = get_node(PlayerNode)


func _ready():
	pass
	

onready var health = $container/Container/health
onready var leafAmmo = $container/HBoxContainer/leaf/ammo
onready var mushroomAmmo = $container/HBoxContainer/shroom/ammo
onready var mushroomContainer =$container/HBoxContainer/shroom/Container
onready var leafContainer =$container/HBoxContainer/leaf/Container
onready var flowerContainer = $container/HBoxContainer/flower/Container

func _process(delta):
	health.frame = Player.health
	if !Player.canPlant && $container/HBoxContainer.get_modulate() != Color(0,0,0):
		$container/HBoxContainer.set_modulate(Color(0, 0,0))
	if Player.canPlant && $container/HBoxContainer.get_modulate() != Color(1,1,1):
		$container/HBoxContainer.set_modulate(Color(1, 1,1))
	match Player.equipped.type:
		"mushroom":
			if !mushroomContainer.pressed:
				mushroomContainer.set_pressed_no_signal(true)
				leafContainer.set_pressed_no_signal(false)
				flowerContainer.set_pressed_no_signal(false)
		"leaf":
			if !leafContainer.pressed:
				mushroomContainer.set_pressed_no_signal(false)
				leafContainer.set_pressed_no_signal(true)
				flowerContainer.set_pressed_no_signal(false)
		"flower":
			if !flowerContainer.pressed:
				mushroomContainer.set_pressed_no_signal(false)
				leafContainer.set_pressed_no_signal(false)
				flowerContainer.set_pressed_no_signal(true)
