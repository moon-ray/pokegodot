extends Area2D

@export_enum("UP_WARP", "DOWN_WARP", "TILE_WARP") var warp_type
@export_enum("LEFT", "RIGHT", "UP", "DOWN") var direction_after_warp
@export var warp_to : Vector2

@export var move_one_after : bool

var sfxin = preload("res://sfx/p-rby-gsfx/SFX_GO_INSIDE.ogg")
var sfxout = preload("res://sfx/p-rby-gsfx/SFX_GO_OUTSIDE.ogg")

var sfxs = [sfxin, sfxout]

@export_enum("INSIDE", "OUTSIDE") var sound_effect

@onready var pllr = get_tree().root.get_node("World").get_node("Player")


func _process(delta):
	if pllr.get_node("hitbox") in get_overlapping_areas() and !pllr.warping and !pllr.is_moving:
		match warp_type:
			0:
				if Input.is_action_pressed("ui_up"):
					warp(pllr)
					pllr.player_direction = pllr.directions.UP
					update_player_dir(pllr)
			1:
				if Input.is_action_pressed("ui_down"):
					warp(pllr)
					pllr.player_direction = pllr.directions.DOWN
					update_player_dir(pllr)


func update_player_dir(plr):
	match plr.player_direction:
		plr.directions.UP:
			plr.manual_input = Vector2(0, -1)
		plr.directions.LEFT:
			plr.manual_input = Vector2(-1, 0)
		plr.directions.DOWN:
			plr.manual_input = Vector2(0, 1)
		plr.directions.RIGHT:
			plr.manual_input = Vector2(1, 0)


func _on_area_entered(area):
	if area.get_parent().name == "Player":
		var plr = area.get_parent()
		if !plr.warping:
			if warp_type == 2:
				while plr.is_moving:
					await get_tree().create_timer(0.000000000000000000000000000000000000000000000000000000000000000000000000000000000001).timeout
				warp(plr)
			



func warp(plr):
	AudioManager.play_sfx_track2(sfxs[sound_effect], 0, false)
	plr.warping = true
	plr.can_move = false
	UI.get_node("Color/AnimationPlayer").play("warp")
	await get_tree().create_timer(0.3).timeout
	plr.position = warp_to
	plr.player_direction = direction_after_warp
	match plr.player_direction:
		plr.directions.UP:
			plr.manual_input = Vector2(0, -1)
		plr.directions.LEFT:
			plr.manual_input = Vector2(-1, 0)
		plr.directions.DOWN:
			plr.manual_input = Vector2(0, 1)
		plr.directions.RIGHT:
			plr.manual_input = Vector2(1, 0)
	await get_tree().create_timer(0.3).timeout
	if move_one_after:
		plr.moving_manually = true
		await get_tree().create_timer(0.25).timeout
		plr.moving_manually = false
	await get_tree().create_timer(0.1).timeout
	plr.can_move = true
	plr.warping = false
