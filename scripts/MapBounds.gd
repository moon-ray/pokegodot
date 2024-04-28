extends Area2D

@onready var world = get_parent().get_parent().get_parent()
@export var music : AudioStream
@export var place_name : String
@export var hide : bool
var playerAreaCount = 0

@onready var pllr = get_tree().root.get_node("World").get_node("Player")

func _process(delta):
	if hide:
		if pllr.get_node("hitbox") in get_overlapping_areas():
			get_parent().visible = true
		else:
			get_parent().visible = false


func _on_area_entered(area):
	if area.get_parent().name == "Player":
		var plr = area.get_parent()
		world.current_area = place_name
