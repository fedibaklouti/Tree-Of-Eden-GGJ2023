extends ParallaxBackground

export (NodePath) var playernode

onready var player = get_node(playernode)

export var speed = 10

var playerspeed 

func _process(delta):
	if player.dir != 0 && abs(player.velocity.x) > 50:
		playerspeed = player.velocity.x/ 100
	else:
		playerspeed = 1
	scroll_offset.x += speed * delta * (playerspeed)
