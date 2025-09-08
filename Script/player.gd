extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var back_marker: Marker2D = $PackageOffset
@onready var dash_bar = $"/root/Main/UI/HUD/DashBar"
@onready var sfx_walk_player: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var sfx_jump_player: AudioStreamPlayer2D = $AudioStreamPlayer2D2
@onready var sfx_explosion_player: AudioStreamPlayer2D = $AudioStreamPlayer2D3

@export var speed: float = 70.0
@export var jump_velocity: float = -200.0
@export var dash_speed: float = 220.0
@export var dash_duration: float = 0.18
@export var dash_cost: float = 50.0
@export var dash_regen_rate: float = 500.0

var dash_time_left := 0.0
var last_facing_direction := 1.0
var has_package := false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

signal action_pressed


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
		if sfx_jump_player != null:
			sfx_jump_player.play()

	# Get the input direction: -1, 0, 1
	var direction = Input.get_axis("move_left", "move_right")
	if direction > 0:
		last_facing_direction = 1.0
	elif direction < 0:
		last_facing_direction = -1.0

	# Footstep SFX
	if is_on_floor() and direction != 0 and dash_time_left <= 0.0:
		if not sfx_walk_player.playing:
			sfx_walk_player.play()
	else:
		if sfx_walk_player.playing:
			sfx_walk_player.stop()

	# Start dash if pressed and enough energy
	if Input.is_action_just_pressed("dash") and dash_bar and dash_bar.is_ready_to_dash() and dash_bar.can_consume(dash_cost):
		dash_time_left = dash_duration
		dash_bar.consume(dash_cost)
		sfx_explosion_player.play()
	
	# Flip the Sprite
	if direction > 0:
		animated_sprite.flip_h = false
		back_marker.position = Vector2(-15, 8)
	elif direction < 0:
		animated_sprite.flip_h = true
		back_marker.position = Vector2(15, 8)
	
	# Play animations
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	
	# Apply movement
	if dash_time_left > 0.0:
		var dash_dir = direction if direction != 0 else last_facing_direction
		velocity.x = dash_dir * dash_speed
		dash_time_left -= delta
	else:
		if direction:
			velocity.x = direction * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()

	if Input.is_action_just_pressed("action"):
		print("Action pressed")
		action_pressed.emit()


