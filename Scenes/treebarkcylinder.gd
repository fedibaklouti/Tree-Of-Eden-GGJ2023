extends Polygon2D

export (NodePath) var playernode


onready var player = get_node(playernode)

func _physics_process(delta):
	if abs(player.velocity.x) > 0:
		texture_offset.x += sign(player.velocity.x) * (abs(player.velocity.x) / player.maxSpeed) * 2
	if abs(player.velocity.y) > 100:
		texture_offset.y += sign(player.velocity.y) * 2 * (abs(player.velocity.y) / (player.JUMPHEIGHT))
