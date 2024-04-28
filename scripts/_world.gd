extends Node2D

var current_area : String

var s = false
var sddds = false

func _process(delta):
	if Input.is_action_just_pressed("ui_accept") and !sddds:
		sddds = true
		_dready()


func _dready():
	$Player.can_move = false
	UI.get_node("Main/box").enabled = true
	#UI.get_node("Main/box").start_text_prompt("Are you a boy?         or a girl?", ["BOY", "GIRL"]) 33 word limit before crash
	UI.get_node("Main/box").start_text_prompt("Are you a boy?         or a girl?", ["BOY", "GIRL"], true)
	while UI.get_node("Main/box").prompt_texting:
		await get_tree().create_timer(0.00000000000001).timeout
	if UI.get_node("Main/box").output == 0:
		$Player.boy()
	else:
		$Player.girl()
	UI.get_node("Main/box").enabled = false
	$Player.can_move = true
