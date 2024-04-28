extends CharacterBody2D

@export var trainer : Resource

const TILE_SIZE: int = 64
const MOVE_SPEED: float = 256.001  # Pixels per second

var target_position: Vector2
var is_moving: bool = false

@onready var right = $right
@onready var up = $up
@onready var left = $left
@onready var down = $down

var collision_sound = preload("res://sfx/p-rby-gsfx/SFX_COLLISION.ogg")

var warping = false
var jumping = false

var boy_s = preload("res://sprites/overworld-sprites/red.png")
var girl_s = preload("res://sprites/overworld-sprites/blue.png")

@onready var anim_tree = $AnimationTree
@onready var anim_state = anim_tree.get("parameters/playback")

enum directions {LEFT, RIGHT, UP, DOWN}

var player_direction = directions.DOWN

var input_direction: Vector2
var input_direction_2 : Vector2

var can_move = true
var moving_manually = false

var manual_input : Vector2

var target__position: Vector2

var in_grass = false

var numc = 0.00

func boy():
	$Sprite2D.texture = boy_s
	
func girl():
	$Sprite2D.texture = girl_s

func _ready():
	anim_state.travel("Idle", false)
	anim_tree.set("parameters/Idle/blend_position", Vector2(0, 1))
	toggle_sprite_dummy(false)

func _physics_process(delta: float) -> void:
	$Dummy.texture = $Sprite2D.texture
	if manual_input != Vector2.ZERO:
		target__position = position + manual_input * TILE_SIZE
	#print(player_direction)
	
	if moving_manually:
		anim_state.travel("Walk", false)
		moveManually(delta, manual_input)
	
	if can_move:
		handlePlayerDirections()
	else:
		input_direction = Vector2.ZERO
	#print(player_direction)
	#print(input_direction_2)
	anim_tree.advance(delta)

	if is_moving:
		anim_state.travel("Walk", false)
		movePlayer(delta)
	else:
		if can_move:
			handleInput()
		if input_direction == Vector2.ZERO and input_direction_2 == Vector2.ZERO:
			print("ASD")
			anim_state.travel("Idle", false)
	match player_direction:
		directions.UP:
			anim_tree.set("parameters/Idle/blend_position", Vector2(0, -1))
			anim_tree.set("parameters/Walk/blend_position", Vector2(0, -1))
		directions.LEFT:
			anim_tree.set("parameters/Idle/blend_position", Vector2(-1, 0))
			anim_tree.set("parameters/Walk/blend_position", Vector2(-1, 0))
		directions.DOWN:
			anim_tree.set("parameters/Idle/blend_position", Vector2(0, 1))
			anim_tree.set("parameters/Walk/blend_position", Vector2(0, 1))
		directions.RIGHT:
			anim_tree.set("parameters/Idle/blend_position", Vector2(1, 0))
			anim_tree.set("parameters/Walk/blend_position", Vector2(1, 0))
				
				
				

func handlePlayerDirections() -> void:
	if !is_moving:
		if Input.is_action_pressed("ui_up"):
			player_direction = directions.UP
		if Input.is_action_pressed("ui_down"):
			player_direction = directions.DOWN
		if Input.is_action_pressed("ui_right"):
			player_direction = directions.RIGHT
		if Input.is_action_pressed("ui_left"):
			player_direction = directions.LEFT

func handleInput() -> void:

	input_direction = Vector2.ZERO

	if Input.is_action_pressed("ui_up") and Input.is_action_pressed("ui_left") and Input.is_action_pressed("ui_right"):
		return
	if Input.is_action_pressed("ui_down") and Input.is_action_pressed("ui_left") and Input.is_action_pressed("ui_right"):
		return
		
	if Input.is_action_pressed("ui_up"):
		if !up.is_colliding():
			input_direction.y -= 1
		else:
			input_direction_2 = Vector2(0, -1)
			anim_state.travel("Walk", false)
			playCollisionSound()
			#input_direction_2 = Vector2(0, 0)
			return
			
	if Input.is_action_pressed("ui_down"):
		if !down.is_colliding():
			input_direction.y += 1
		else:
			anim_state.travel("Walk", false)
			input_direction_2 = Vector2(0, 1)
			playCollisionSound()
			#input_direction_2 = Vector2(0, 0)
			return

	if Input.is_action_pressed("ui_left"):
		if !left.is_colliding():
			input_direction.x -= 1
		else:
			input_direction_2 = Vector2(-1, 0)
			anim_state.travel("Walk", false)
			playCollisionSound()
			#input_direction_2 = Vector2(0, 0)
			return

	if Input.is_action_pressed("ui_right"):
		if !right.is_colliding():
			input_direction.x += 1
		else:
			input_direction_2 = Vector2(1, 0)
			anim_state.travel("Walk", false)
			playCollisionSound()
			#input_direction_2 = Vector2(0, 0)
			return
	input_direction_2 = Vector2(0, 0)
	# prevent from illegally moving diagonal lol
	if abs(input_direction.x) > 0 and abs(input_direction.y) > 0:
		input_direction = Vector2(input_direction.x, 0)
		
	elif abs(input_direction.x) > 0 or abs(input_direction.y) > 0:
		input_direction = input_direction.normalized()

	if input_direction != Vector2.ZERO:
		target_position = position + input_direction * TILE_SIZE
		is_moving = true
		
	#print(input_direction)

func moveManually(delta: float, input):
	
	
	var velocity = (target__position - position).normalized() * MOVE_SPEED
	var distance = velocity * delta / 2
	
	if distance.length() > (target__position - position).length():
		velocity = target__position - position
		is_moving = false
				
	set_velocity(velocity)
	move_and_slide()

func movePlayer(delta: float) -> void:
	var velocity = (target_position - position).normalized() * MOVE_SPEED
	var distance = velocity * delta / 2

	if distance.length() > (target_position - position).length() or is_equal_approx((target_position - position).length(), distance.length()):
		velocity = Vector2.ZERO
		is_moving = false
				
	set_velocity(velocity)
	move_and_slide()

func playGrass():
	if !$Grass/AnimationPlayer.is_playing():
		$Grass/AnimationPlayer.play("Grass")

func playCollisionSound() -> void:
	if !AudioManager.is_playing_sfx():
		anim_tree.set("parameters/Idle/blend_position", input_direction_2)
		anim_tree.set("parameters/Walk/blend_position", input_direction_2)
		AudioManager.play_sfx(collision_sound, 0, false)

func toggle_sprite_dummy(v : bool):
	$Sprite2D.visible = !v
	$Dummy.visible = v
	$Shadow.visible = v

func jump_anim():
	toggle_sprite_dummy(true)
	$Dummy/AnimationPlayer.play("jump")


func _on_dummy_animation_finished(anim_name):
	toggle_sprite_dummy(false)
