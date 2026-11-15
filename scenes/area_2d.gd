extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if get_tree().current_scene.scene_file_path == "res://scenes/1TUTORIAL.tscn":
		get_tree().change_scene_to_file("res://scenes/2TUTORIAL.tscn")
	if get_tree().current_scene.scene_file_path == "res://scenes/2TUTORIAL.tscn":
		get_tree().change_scene_to_file("res://scenes/3MAZE.tscn")
	if get_tree().current_scene.scene_file_path == "res://scenes/3MAZE.tscn":
		get_tree().change_scene_to_file("res://scenes/4TRIAL.tscn")
	if get_tree().current_scene.scene_file_path == "res://scenes/4TRIAL.tcsn":
		get_tree().change_scene_to_file("res://scenes/5CAVE.tscn")
	if get_tree().current_scene.scene_file_path == "res://scenes/5CAVE.tcsn":
		get_tree().change_scene_to_file("res://scenes/6REVERSE.tscn")
	if get_tree().current_scene.scene_file_path == "res://scenes/6REVERSE.tcsn":
		get_tree().change_scene_to_file("res://scenes/8BOSSFIGHT.tscn")
