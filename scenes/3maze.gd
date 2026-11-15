extends Node2D

@onready var character_body_2d: CharacterBody2D = $CharacterBody2D
const FLOAT_SPEED: float = 300.0

func _ready() -> void:
	# 1. Disable jump for this level
	InputMap.action_erase_events("jump")
	
	# 2. Create temporary "level_up" and "level_down" actions for W and S
	if not InputMap.has_action("level_up"):
		InputMap.add_action("level_up")
	var up := InputEventKey.new()
	up.physical_keycode = KEY_W
	InputMap.action_add_event("level_up", up)
	
	if not InputMap.has_action("level_down"):
		InputMap.add_action("level_down")
	var down := InputEventKey.new()
	down.physical_keycode = KEY_S
	InputMap.action_add_event("level_down", down)
	
	# 3. Scale down the character
	character_body_2d.scale = Vector2(0.5, 0.5)

func _physics_process(delta: float) -> void:
	# Read W (-1) and S (+1) to move up and down
	var vertical_dir := Input.get_axis("level_up", "level_down")
	
	# Override vertical velocity to cancel gravity and apply floating movement
	character_body_2d.velocity.y = vertical_dir * FLOAT_SPEED
	character_body_2d.move_and_slide()

func _exit_tree() -> void:
	# Clean up custom actions and restore your original controls when leaving
	if InputMap.has_action("level_up"):
		InputMap.erase_action("level_up")
	if InputMap.has_action("level_down"):
		InputMap.erase_action("level_down")
	InputMap.load_from_project_settings()
