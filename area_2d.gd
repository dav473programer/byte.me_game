extends Area2D

var direction: Vector2 = Vector2.ZERO
@onready var character_body_2d: CharacterBody2D = $CharacterBody2D
var speed: float = 350.0

func _process(delta: float) -> void:
	# Moves the projectile forward every frame
	position += direction * speed * delta

# Connect the "body_entered" signal of this Area2D
func _on_body_entered(body: Node2D) -> void:
	# Replace "player" with whatever group your CharacterBody2D uses
	if body.is_in_group("player") or body == get_tree().get_first_node_in_group("player"):
		# Deal damage here if your player has a health script, e.g.:
		get_tree().reload_current_scene()
		
		# Destroy the fireball upon impact
		queue_free()
