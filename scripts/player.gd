extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var audio_stream_player_2d_2: AudioStreamPlayer2D = $AudioStreamPlayer2D2


const SPEED = 300.0
const JUMP_VELOCITY = -800.0


func _physics_process(delta: float) -> void:
	if velocity.x > 1 and is_on_floor():
		animated_sprite_2d.animation = "walk"
		animated_sprite_2d.flip_h = false
		if not audio_stream_player_2d_2.playing:
			audio_stream_player_2d_2.play()
	if velocity.x < -1 and is_on_floor():
		animated_sprite_2d.animation = "walk"
		animated_sprite_2d.flip_h = true
		if not audio_stream_player_2d_2.playing:
			audio_stream_player_2d_2.play()
	if velocity.x == 0:
		animated_sprite_2d.animation = "idle"
	print(velocity.x)
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		if velocity.x < 1 and velocity.x > -1:
			animated_sprite_2d.animation = "jump"

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		audio_stream_player_2d.play()
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	move_and_slide()
