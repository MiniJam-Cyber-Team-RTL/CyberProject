extends Node2D

var player_entered = false
var player = null
var is_alive = true
var is_hurt = false
var old_x


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	old_x = global_position.x
	pass # Replace with function body.


func puzzle():
	pass

func destroy():
	print("JE suis une door qui meurt")
	$AnimatedSprite2D.play("death")
	$RigidBody2D/CollisionShape2D.disabled = true

func _on_interact_zone_body_entered(body: Node2D) -> void:
	if body.has_method('player'):
		player_entered = true
		player = body


func _on_interact_zone_body_exited(body: Node2D) -> void:
		player_entered = false
		player = null
