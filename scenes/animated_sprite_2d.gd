extends AnimatedSprite2D

@onready var character_body_2d: CharacterBody2D = $"../CharacterBody2D"

# Export variables so you can adjust them right in the Godot Inspector
@export var fire_scene: PackedScene = preload("res://fp.tscn")
@export var shoot_interval: float = 1.8  # Seconds between each fireball
@export var detection_range: float = 450.0 # Maximum distance to trigger shooting

var shoot_timer: float = 0.0

func _ready() -> void:
	# Plays an idle animation automatically if you've created one in SpriteFrames
	if sprite_frames and sprite_frames.has_animation("idle"):
		play("idle")

func _process(delta: float) -> void:
	if not character_body_2d:
		return

	# 1. Calculate direction and distance to the target
	var target_pos = character_body_2d.global_position
	var to_target = target_pos - global_position
	var distance = to_target.length()

	# 2. Smoothly rotate/aim the AnimatedSprite2D directly at the target
	rotation = to_target.angle()

	# 3. Handle firing logic when the target is within range
	if distance <= detection_range:
		shoot_timer += delta
		if shoot_timer >= shoot_interval:
			shoot_timer = 0.0
			shoot_fireball()
	else:
		# Reset timer slightly so it shoots immediately when player re-enters range
		shoot_timer = max(0.0, shoot_timer - delta)

func shoot_fireball() -> void:
	# Play a "shoot" or "attack" animation if you have one set up
	if sprite_frames and sprite_frames.has_animation("shoot"):
		play("shoot")
		# Optional: queue back to idle after animation finishes, 
		# or let AnimatedSprite2D handle loops.

	if fire_scene:
		var fire = fire_scene.instantiate()
		
		# Place it at the shooter's current position
		fire.global_position = global_position
		
		# Pass the movement vector to the projectile
		var fire_direction = (character_body_2d.global_position - global_position).normalized()
		if "direction" in fire:
			fire.direction = fire_direction
		if "rotation" in fire:
			fire.rotation = fire_direction.angle()
			
		# Add it to the main scene tree so it moves freely across the level
		get_tree().current_scene.add_child(fire)
