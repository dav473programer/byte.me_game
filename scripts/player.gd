extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var audio_stream_player_2d_2: AudioStreamPlayer2D = $AudioStreamPlayer2D2
@onready var tile_map: TileMapLayer = $"../TileMapLayer"

@export var gravity_enabled: bool = true

const SPEED = 300.0
const FLOAT_SPEED = 300.0
const JUMP_VELOCITY = -800.0
const CLIMB_SPEED = 200.0

var fr = true
var xaddr = 0
var dir = false
var is_dead = false

func _physics_process(delta: float) -> void:
	# Stop movement & extra triggers while dying or spawning in
	if is_dead:
		return

	if fr:
		is_dead = true
		animated_sprite_2d.speed_scale = -1
		animated_sprite_2d.play("die")
		await get_tree().create_timer(1.4).timeout
		animated_sprite_2d.speed_scale = 1
		animated_sprite_2d.play("idle")
		fr = false
		is_dead = false
		return

	if Input.is_action_just_pressed("restart"):
		die()
		return

	# Walk & Idle Animations
	if velocity.x > 1 and is_on_floor():
		animated_sprite_2d.animation = "walk"
		animated_sprite_2d.flip_h = false
		if not audio_stream_player_2d_2.playing:
			audio_stream_player_2d_2.play()
	elif velocity.x < -1 and is_on_floor():
		animated_sprite_2d.animation = "walk"
		animated_sprite_2d.flip_h = true
		if not audio_stream_player_2d_2.playing:
			audio_stream_player_2d_2.play()
	elif velocity.x == 0 and not is_on_wall() and animated_sprite_2d.animation != "die":
		animated_sprite_2d.animation = "idle"

	# Gravity vs. Zero-Gravity Floating Mode
	if gravity_enabled:
		if not is_on_floor():
			velocity += get_gravity() * delta
			if velocity.x < 1 and velocity.x > -1 and not is_on_wall():
				animated_sprite_2d.animation = "jump"
	else:
		# Uses your special level's W/S actions when gravity is disabled
		if InputMap.has_action("level_up") and InputMap.has_action("level_down"):
			var vertical_dir := Input.get_axis("level_up", "level_down")
			velocity.y = vertical_dir * FLOAT_SPEED

	# Tile Data Checks (Wall & Body)
	var col = get_last_slide_collision()
	var map = col.get_collider() if col and col.get_collider() is TileMapLayer else null
	var wall_tile = map.get_cell_tile_data(map.local_to_map(map.to_local(col.get_position() - col.get_normal() * 2.0))) if map else null
	var body_tile = tile_map.get_cell_tile_data(tile_map.local_to_map(tile_map.to_local(global_position))) if tile_map else null

	var blocked = (wall_tile and wall_tile.get_custom_data("nclimbable")) or (body_tile and body_tile.get_custom_data("nclimbable"))

	# Wall Climbing & Wall Jump
	if gravity_enabled and is_on_wall() and not blocked and (Input.is_action_pressed("left") or Input.is_action_pressed("right")):
		velocity.y = -CLIMB_SPEED
		if Input.is_action_pressed("left"):
			animated_sprite_2d.rotation_degrees = move_toward(animated_sprite_2d.rotation_degrees, 90, 15)
			dir = true
		if Input.is_action_pressed("right"):
			animated_sprite_2d.rotation_degrees = move_toward(animated_sprite_2d.rotation_degrees, -90, 15)
			dir = false
		if Input.is_action_pressed("jump"):
			if not dir:
				xaddr = -1000
			else:
				xaddr = 1000
			velocity.y = -500
	else:
		animated_sprite_2d.rotation_degrees = move_toward(animated_sprite_2d.rotation_degrees, 0, 15)

	# Normal Jump
	if gravity_enabled and Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		audio_stream_player_2d.play()

	# Wall Jump Momentum Decay
	if xaddr != 0:
		if velocity.y == 0:
			velocity.y += 10
		if not dir:
			xaddr += 50
		else:
			xaddr -= 50

	# Horizontal Movement
	var direction := Input.get_axis("left", "right")
	if xaddr == 0:
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	else:
		velocity.x = xaddr

	move_and_slide()
	check_deadly_tiles(body_tile)

func check_deadly_tiles(body_tile: TileData) -> void:
	# 1. Check if overlapping a non-solid hazard tile (like spikes without physics collision)
	if body_tile and body_tile.get_custom_data("die") == true:
		die()
		return

	# 2. Check all solid tiles bumped into during move_and_slide()
	for i in get_slide_collision_count():
		var collision := get_slide_collision(i)
		var collider := collision.get_collider()
		if collider is TileMapLayer:
			var hit_pos := collision.get_position() - collision.get_normal() * 2.0
			var tile_coords: Vector2i = collider.local_to_map(collider.to_local(hit_pos))
			var tile_data: TileData = collider.get_cell_tile_data(tile_coords)
			if tile_data and tile_data.get_custom_data("die") == true:
				die()
				return

func die() -> void:
	if is_dead:
		return
	is_dead = true
	velocity = Vector2.ZERO
	animated_sprite_2d.rotation_degrees = 0
	animated_sprite_2d.speed_scale = 1
	animated_sprite_2d.play("die")
	await get_tree().create_timer(1.4).timeout
	get_tree().reload_current_scene()
