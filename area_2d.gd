extends Area2D

var direction: Vector2 = Vector2.ZERO
var speed: float = 350.0

func _ready() -> void:
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	# Move the fireball smoothly
	global_position += direction * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body.name == "CharacterBody2D" or body.is_in_group("player"):
		print("🔥 HIT PLAYER!")
		
		# Check if the player has the "take_hit" function and call it
		if body.has_method("take_hit"):
			body.take_hit()
		else:
			# Fallback if the function isn't there yet
			get_tree().reload_current_scene()
			
		queue_free()
	else:
		print("💥 Hit wall/environment: ", body.name)
		queue_free()
