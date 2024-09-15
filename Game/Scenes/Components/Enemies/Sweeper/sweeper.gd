extends CharacterBody2D
class_name Sweeper


@onready var animation = $AnimatedSprite2D


var player_entered = false
var player = false
var ATTACK_COOLDOWN = 1.5
var cooldowned : bool = false
var msg = ""
var is_hurt = false

const SPEED = 1
const DAMAGE : int = 1
var health : int = 3
var is_alive : bool = true
var old_x = 0
signal switch_progression(value : bool)

func _ready() -> void:
	print("I'm here to clean this up !")
	old_x = global_position.x
	$Timer.wait_time = ATTACK_COOLDOWN

func _physics_process(delta: float) -> void:
	if is_alive and !is_hurt:
		if player_entered:
			animation.flip_h = player.position.x < global_position.x
			if !cooldowned:
				#msg="player entered & not cooldowned"
				animation.play("attack")
			else:
				if !animation.is_playing():
					#msg="player entered & cooldowned"
					animation.play("idle")
		else:
			if (global_position.x != old_x):
				$AnimatedSprite2D.flip_h = global_position.x < old_x
				#msg="no player & global_position.x != old_x"
				animation.play("walk")
				old_x = global_position.x
			else:
				#msg="other"
				animation.play("idle")




func decrease_health(delta : int):
	if health > 0:
		hurted()
		health -= abs(delta)

func hurted():
	is_hurt = true
	switch_progression.emit(false)
	animation.stop()
	animation.play("hurt")


func _on_area_2d_body_entered(body: Node2D) -> void:
	player_entered = true
	switch_progression.emit(false)
	player = body

func _on_area_2d_body_exited(body: Node2D) -> void:
	player_entered = false
	switch_progression.emit(true)
	player = null



func _on_animated_sprite_2d_frame_changed() -> void:
	if animation.animation == "attack" and animation.frame == 4:
		print("Je tape le player")
		player.take_damage(DAMAGE)
		$Timer.start(ATTACK_COOLDOWN)
		cooldowned = true

func _on_animated_sprite_2d_animation_finished() -> void:
	if animation.animation == "hurt":
		if health < 1 and is_alive:
			animation.play("death")
		else:
			if !player_entered:
				switch_progression.emit(true)
			is_hurt = false
	elif animation.animation == "death":
		is_alive = false



func _on_timer_timeout() -> void:
	cooldowned = false
