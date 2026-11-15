extends Node2D
@onready var character_body_2d: CharacterBody2D = $CharacterBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	character_body_2d.scale = Vector2(0.5, 0.5)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
