extends Control

signal resume

func _ready() -> void:
	$PauseMusic.play()
	
func _on_button_pressed() -> void:
	$ConfirmButton.play()
	await get_tree().create_timer(1.0).timeout
	$PauseMusic.stop()
	resume.emit()

func _on_button_2_pressed() -> void:
	$ConfirmButton.play()
	await get_tree().create_timer(1.0).timeout
	$PauseMusic.stop()
	get_tree().quit()
	
func _physics_process(delta: float) -> void:
	if !$"PauseMusic".is_playing():
			$"PauseMusic".play()
