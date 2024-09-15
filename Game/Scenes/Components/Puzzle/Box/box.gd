extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func destroy():
	$AnimatedSprite2D_Main.play("death")
	self.translate(Vector2(900,900))



func _on_interact_zone_area_entered(area: Area2D) -> void:
	# TODO display a GUI prompt interact
	pass # Replace with function body.
