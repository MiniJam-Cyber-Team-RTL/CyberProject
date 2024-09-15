extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$music.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !$music.playing:
		$music.play()

func _on_retry_pressed() -> void:
	$AudioStreamPlayer2D.play()
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://Scenes/Screens/Main/main.tscn")



func _on_quit_pressed() -> void:
	$AudioStreamPlayer2D.play()
	await get_tree().create_timer(1.0).timeout
	get_tree().quit()
