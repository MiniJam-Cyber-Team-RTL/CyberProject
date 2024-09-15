extends Control

var confirm_sound = preload("res://Assets/Sounds/UI/UI_confirm.wav")

func _physics_process(delta: float) -> void:
	if !$music.playing:
		$music.play()

func _ready():
	$music.play()

func _on_play_pressed() -> void:
	$AudioStreamPlayer2D.stream = confirm_sound
	$AudioStreamPlayer2D.play()
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://Scenes/Screens/Main/main.tscn")


func _on_quit_game_pressed() -> void:
	$AudioStreamPlayer2D.stream = confirm_sound
	$AudioStreamPlayer2D.play()
	await get_tree().create_timer(1.0).timeout
	get_tree().quit()
