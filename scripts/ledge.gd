extends Area2D

@onready var plr = get_tree().root.get_node("World").get_node("Player")

var sfx = preload("res://sfx/p-rby-gsfx/SFX_LEDGE.ogg")

func _process(delta):
	if plr.get_node("hitbox") in get_overlapping_areas():
		if !plr.jumping and !plr.is_moving:
			if Input.is_action_pressed("ui_down"):
				var plr_inital_y = plr.position.y
				plr.is_moving = false
				plr.can_move = false
				plr.jumping = true
				plr.manual_input = Vector2(0, 1)
				plr.moving_manually = true
				plr.jump_anim()
				plr.player_direction = plr.directions.DOWN
				AudioManager.play_sfx(sfx, 0, false)
				await get_tree().create_timer(0.25).timeout
				plr.moving_manually = false
				plr.moving_manually = true
				await get_tree().create_timer(0.25).timeout
				plr.moving_manually = false
				plr.can_move = true
				plr.jumping = false
				if plr.position.y != plr_inital_y:
					plr.position.y = (plr_inital_y + 128)
		
