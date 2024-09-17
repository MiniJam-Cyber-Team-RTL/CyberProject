extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_end_level_area_area_entered(area: Area2D) -> void:
	get_tree().change_scene_to_file("res://Scenes/Components/UI/Menu/end.tscn")


func _on_player_update_ui() -> void:
	var ui = get_parent().get_node("CanvasLayer/MarginContainer")
	ui.update_damage($Player/Timer_Power.time_left)
	ui.update_speed($Player/Timer_Speed.time_left)
	ui.update_health($Player.player_life)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		get_tree().change_scene_to_file("res://Scenes/Components/UI/Menu/end.tscn")
