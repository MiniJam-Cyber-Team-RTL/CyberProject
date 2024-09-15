extends Control

signal resume

func _on_button_pressed() -> void:
	resume.emit()
