extends NinePatchRect


var texting = false
var blinking = false
var skippable_texting = false
var prompt_texting = false

var enabled = false

var output = 0

var ab = preload("res://sfx/p-rby-gsfx/SFX_PRESS_AB.ogg")
# Called when the node enters the scene tree for the first time.
func _ready():
	$Prompt.visible = false

func clear_text():
	$RichTextLabel.text = ""

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if enabled:
		visible = true
	else:
		visible = false
	
	if Input.is_action_just_pressed("ui_accept") and blinking:
		blinking = false
		$Arrow/blinker.stop()
		$Arrow.visible = false
		AudioManager.play_sfx(ab, 0, false)
		
	
	pass

func start_text_skippable(text : Array):
	skippable_texting = true
	for t in text:
		if t == "":
			break
		print(t)
		texting = true
		$RichTextLabel.visible_ratio = 0
		$RichTextLabel.text = t
		$AnimationPlayer.speed_scale = get_multiplier(text)
		$AnimationPlayer.play("scroll")
		while texting:
			await get_tree().create_timer(0.1).timeout
		$Arrow/blinker.play("blink")
		blinking = true
		while blinking:
			await get_tree().create_timer(0.1).timeout
	skippable_texting = false
	

func start_text(text):
	if !texting:
		texting = true
		$RichTextLabel.visible_ratio = 0
		$RichTextLabel.text = text
		$AnimationPlayer.speed_scale = get_multiplier(text)
		$AnimationPlayer.play("scroll")


func start_text_prompt(text, prompt : Array, space : bool):
	if !texting:
		$Prompt.size.y = 34
		$Prompt.position.y = -34
		prompt_texting = true
		texting = true
		$RichTextLabel.visible_ratio = 0
		$RichTextLabel.text = text
		$AnimationPlayer.speed_scale = get_multiplier(text)
		print(get_multiplier(text))
		$AnimationPlayer.play("scroll")
		var t2 = ""
		for t in prompt.size():
			t2 += prompt[t]
			if space:
				t2 += " "
		$Prompt/Options.text = str(t2)
		while texting:
			await get_tree().create_timer(0.1).timeout
		$Prompt.visible = true
		var count = 0
		var total = prompt.size() - 1
		
		for n in prompt.size() - 2:
			$Prompt.size.y += 14
			$Prompt.position.y -= 14
		$Prompt/Arrow.position.y = 7
		
		while true:
			#print(count)
			await get_tree().create_timer(0.00000000000001).timeout
			if Input.is_action_just_pressed("ui_down"):
				$Prompt/Arrow.position.y += 13
				if !(count + 1 > total):
					count += 1
				else:
					count = 0
					$Prompt/Arrow.position.y = 7
			if Input.is_action_just_pressed("ui_up"):
				$Prompt/Arrow.position.y -= 13
				if !(count - 1 < 0):
					count -= 1
				else:
					count = total
					$Prompt/Arrow.position.y = get_y(7, total, 13)
			if Input.is_action_just_pressed("ui_accept"):
				AudioManager.play_sfx(ab, 0, false)
				break
		
		prompt_texting = false
		$Prompt.visible = false
		output = count
		
func _on_scrolling_finished(anim_name):
	if anim_name == "scroll":
		texting = false

func get_y(y2, y_add, amount):
	var y = y2
	for a in range(y_add):
		y += amount
	return y


func get_multiplier(text):
	var count = float(text.split('', false).size())
	
	
	return (1.00 - (count/50))

func _on_blinker_finished(anim_name):
	if anim_name == "blink":
		blinking = false
