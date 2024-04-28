extends Area2D

@onready var pllr = get_tree().root.get_node("World").get_node("Player")

var anim = false

func _process(delta):
	if pllr.get_node("hitbox") in get_overlapping_areas():
		$Sprite.visible = true
		if !anim:
			pllr.playGrass()
			anim = true
		if !pllr.is_moving:
			pass
	else:
		$Sprite.visible = false
		anim = false
