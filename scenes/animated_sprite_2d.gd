extends AnimatedSprite2D

@onready var character_body_2d: CharacterBody2D = $"../CharacterBody2D"

# Make sure this path matches the exact name and folder of your projectile scene!
@export var fire_scene: PackedScene = preload("res://fp.tscn")
@export var shoot_interval: float = 1.5
@export var detection_range: float = 800.0 # Increased range so it's harder to be out of range

var shoot_timer: float = 0.0

func _process(delta: float) -> void:
	if not character_body_2d:
		return

	var to_target = character_body_2d.global_position - global_position
	var distance = to_target.length()

	# Aim at the player
	rotation = to_target.angle()

	# Check range and timer
	if distance <= detection_range:
		shoot_timer += delta
		if shoot_timer >= shoot_interval:
			shoot_timer = 0.0
			shoot_fireball()
	else:
		# Temporarily removed the timer penalty so it doesn't get stuck if you walk in/out of range
		pass

func shoot_fireball() -> void:
	if not fire_scene:
		return
		
	var fire = fire_scene.instantiate()
	
	# 1. Add it to the main scene tree FIRST so it has a valid global position
	get_tree().current_scene.add_child(fire)
	
	# 2. THEN set its position right on the shooter
	fire.global_position = global_position
	
	# 3. Pass the direction and rotation
	var fire_direction = (character_body_2d.global_position - global_position).normalized()
	if "direction" in fire:
		fire.direction = fire_direction
	if "rotation" in fire:
		fire.rotation = fire_direction.angle()
		
	print("SUCCESS: Fireball instantiated and added to scene!")
