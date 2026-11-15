extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	get_tree().quit()


func _on_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/1TUTORIAL.tscn")


func _on_button_3_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/2TUTORIAL.tscn") # Replace with function body.


func _on_button_4_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/3MAZE.tscn")


func _on_button_5_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/4TRIAL.tscn")


func _on_button_6_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/5CAVE.tscn") # Replace with function body.


func _on_button_7_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/6REVERSE.tscn") # Replace with function body.


func _on_button_8_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/8BOSSFIGHT.tscn") # Replace with function body.
