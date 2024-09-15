extends Node2D

func _process(delta: float) -> void:
	if Input.is_action_pressed("pause"):
		$CanvasLayer/PauseMenu.show()
		get_tree().paused = true


func _on_pause_menu_resume() -> void:
	$CanvasLayer/PauseMenu.hide()
	get_tree().paused = false
