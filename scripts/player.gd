extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var audio_stream_player_2d_2: AudioStreamPlayer2D = $AudioStreamPlayer2D2
@onready var tile_map: TileMapLayer = $"../TileMapLayer"


const SPEED = 300.0
const JUMP_VELOCITY = -800.0
const CLIMB_SPEED = 200.0

var fr = true
var xaddr = 0
var dir = false

func _physics_process(delta: float) -> void:
	if fr:
		animated_sprite_2d.speed_scale = (-1)
		animated_sprite_2d.animation = "die"
		await get_tree().create_timer(1.4).timeout
		animated_sprite_2d.speed_scale = (1)
		animated_sprite_2d.animation = "idle"
		fr = false
	
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
	if velocity.x == 0 and not is_on_wall() and animated_sprite_2d.animation != "die":
		animated_sprite_2d.animation = "idle"
	print(velocity.x)
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		if velocity.x < 1 and velocity.x > -1 and not is_on_wall():
			animated_sprite_2d.animation = "jump"
	var col = get_last_slide_collision()
	var map = col.get_collider() if col and col.get_collider() is TileMapLayer else null
	var wall_tile = map.get_cell_tile_data(map.local_to_map(map.to_local(col.get_position() - col.get_normal()))) if map else null
	var body_tile = tile_map.get_cell_tile_data(tile_map.local_to_map(tile_map.to_local(global_position))) if tile_map else null

	var blocked = (wall_tile and wall_tile.get_custom_data("nclimbable")) or (body_tile and body_tile.get_custom_data("nclimbable"))

	if Input.is_action_just_pressed("restart"):
		animated_sprite_2d.animation = "die"
		await get_tree().create_timer(1.4).timeout
		get_tree().reload_current_scene()
	
	if is_on_wall() and not blocked and (Input.is_action_pressed("left") or Input.is_action_pressed("right")):
		velocity.y = -CLIMB_SPEED
		if Input.is_action_pressed("left"):
			animated_sprite_2d.rotation_degrees = move_toward(animated_sprite_2d.rotation_degrees, 90, 15)
			dir = true
		if Input.is_action_pressed("right"):
			animated_sprite_2d.rotation_degrees = move_toward(animated_sprite_2d.rotation_degrees, -90, 15)
			dir = false
		if Input.is_action_pressed("jump"):
			print("yay")
			if not dir:
				xaddr = -1000
			else:
				xaddr = 1000
			velocity.y = -500
	else:
		animated_sprite_2d.rotation_degrees = move_toward(animated_sprite_2d.rotation_degrees, 0, 15)
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		audio_stream_player_2d.play()
	
	if xaddr != 0:
		if velocity.y == 0:
			velocity.y += 10
		if not dir:
			xaddr += 50
		else:
			xaddr -= 50

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("left", "right")
	print(direction)
	if xaddr == 0:
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	else:
		velocity.x = xaddr
		
	move_and_slide()
