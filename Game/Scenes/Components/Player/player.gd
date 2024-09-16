extends CharacterBody2D

const JUMP_VELOCITY = -500.0
const POWER_UP_TIMER = 15

var is_facing_right = true
var wait_for_anim_end = false
var is_jumping = false
var is_crouching = false # ras le cul, j'aimerais apprendre les anim tree mais tant pis
var is_running = false # si quelqu'un vois ce code je n'ai plus aucune crédibilitée dans l'univers # tout pareil mec
var is_punching = false

var entered_enemie = false
var entered_puzzle = false
var enemy = null
var puzzle = null
var is_alive = true
var is_hurt = false

var player_speed = 200.0
var player_life = 5;
var player_damage = 1;

@onready var ui = get_node("/root/Main/CanvasLayer/MarginContainer")

var direction
func _ready():
	$AnimatedSprite2D_Power.visible = false
	$AnimatedSprite2D_Speed.visible = false
	$"MusicPlayer".play()
	$Area2D/CollisionShape2D_Right.disabled = true
	$Area2D/CollisionShape2D_Left.disabled = true
	update_ui.emit()

signal update_ui
	
func _physics_process(delta: float) -> void:
	if is_alive and !is_hurt:

		#var ui = get_node("/root/Main/CanvasLayer/MarginContainer")
		direction = Input.get_axis("ui_left", "ui_right")
		is_facing_right = false if direction == -1 else true

		# I think right and left are inverted, somehow
		if is_facing_right:
			$Area2D/CollisionShape2D_Right.disabled = false
			$Area2D/CollisionShape2D_Left.disabled = true
		else:
			$Area2D/CollisionShape2D_Right.disabled = true
			$Area2D/CollisionShape2D_Left.disabled = false

		# Add the gravity.
		if not is_on_floor():
			velocity += get_gravity() * delta
			if !is_jumping:
				play_anim("fall", !is_facing_right)
		else:
			# The Movement
			if direction and (!is_crouching and !is_punching): # Crouch as the priority over movement
				velocity.x = direction * player_speed
				play_anim("run", !is_facing_right)
				is_running = true
			else:
				# If the player does nothing, idle
				if !is_crouching and !is_punching:
					velocity.x = move_toward(velocity.x, 0, player_speed)
					play_anim("idle", !is_facing_right)
					is_punching = false
					is_crouching = false

			# Handle jump.
			if Input.is_action_just_pressed("ui_accept"):
				velocity.y = JUMP_VELOCITY
				change_collision(true, false)
				play_anim("jump", !is_facing_right)
				is_jumping = true
				is_punching = false
				$JumpSound.play()
			# Handle the punch
			if Input.is_action_just_pressed("ui_select"):
				velocity.x = 0
				is_punching = true
				change_collision(true, false)
				play_anim("punch", !is_facing_right)
				$PunchSound.play()
			# Handle crouching and unchrouching
			if Input.is_action_just_pressed("ui_down"):
				is_running = false
				is_crouching = true
				change_collision(false, true)
				play_anim("crouch", !is_facing_right)
				velocity.x = 0
			elif Input.is_action_just_released("ui_down"):
				is_crouching = false
				change_collision(true, false)
				play_anim("crouch", !is_facing_right, false)

			is_jumping = velocity.y < 0

			# C'est DéGEULASSSE mais bon... JE NE SAIT PAS FAIRE DE ANIM TREE AU SECOURS AIDEZ MOIIIIIIIIIII
			if $AnimatedSprite2D_Main.animation == "punch" and $AnimatedSprite2D_Main.frame_progress == 1:
				is_punching = false

		if !$"MusicPlayer".is_playing():
			$"MusicPlayer".play()
		update_ui.emit()

		move_and_slide()


func change_collision(collision1 : bool, collision2: bool):
	$CollisionShape2D.disabled = !collision1
	$CollisionShape2D_Crouch.disabled = !collision2

func play_anim(anim_name : String, face_direction : bool = true, play_forward: bool = true):
	$AnimatedSprite2D_Main.flip_h = face_direction
	$AnimatedSprite2D_Power.flip_h = face_direction
	$AnimatedSprite2D_Speed.flip_h = face_direction
	$AnimatedSprite2D_Main.centered = true
	
	$AnimatedSprite2D_Main.play(anim_name, 1.0, !play_forward)
	$AnimatedSprite2D_Power.play(anim_name + "_red", 1.0, !play_forward)
	$AnimatedSprite2D_Speed.play(anim_name + "_yellow", 1.0, !play_forward)
		
	if anim_name == "punch":
		if face_direction:
			$Area2D/CollisionShape2D_Left.disabled = false
		else: 
			$Area2D/CollisionShape2D_Right.disabled = false
		
	else:
		$Area2D/CollisionShape2D_Left.disabled = true
		$Area2D/CollisionShape2D_Right.disabled = true

func take_damage(damage: int):
	if damage > 0 and is_alive and !is_hurt:
		player_life -= damage
		ui.update_health(player_life)
		is_hurt = true
		play_anim("hurt", !is_facing_right)
		
func pickup_power_up(type):
	$Timer_Power.wait_time = POWER_UP_TIMER
	$Timer_Speed.wait_time = POWER_UP_TIMER
	$Timer_Power.one_shot = true
	$Timer_Speed.one_shot = true
	$PowerUpSound.play()
	# Power power-up
	if type == 1:
		player_damage += 1
		$AnimatedSprite2D_Power.visible = true
		ui.show_power_up(type, POWER_UP_TIMER)
		$Timer_Power.start()
	elif type == 2:
		player_speed = player_speed * 2
		$AnimatedSprite2D_Speed.visible = true
		ui.show_power_up(type, POWER_UP_TIMER)
		$Timer_Speed.start()
	else:
		player_life += 1
		ui.update_health(player_life)
	
#sacré singerie
func player():
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group('enemie'):
		entered_enemie = true
		enemy = body
	if body.get_parent().has_method('puzzle'):
		puzzle = body
		entered_puzzle = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.get_parent().is_in_group('enemie'):
		entered_enemie = false
		enemy = null
	if body.get_parent().has_method('puzzle'):
		puzzle = null
		entered_puzzle = false


func _on_animated_sprite_2d_main_animation_finished() -> void:
	if $AnimatedSprite2D_Main.animation == "hurt":
		if player_life < 1 and is_alive:
			is_alive = false
			$AnimatedSprite2D_Main.play("death")
			await get_tree().create_timer(0.9).timeout
			get_tree().change_scene_to_file("res://Scenes/Screens/Main/main.tscn")
		else:
			is_hurt = false
	elif $AnimatedSprite2D_Main.animation == "death":
		# je fais ca sous la contrainte c'est affreux j'ai honte d'écrire ça
		get_tree().change_scene_to_file("res://Scenes/Screens/Main/main.tscn")

func _on_animated_sprite_2d_main_frame_changed() -> void:
	if $AnimatedSprite2D_Main.animation == "punch" and $AnimatedSprite2D_Main.frame == 4 and entered_enemie:
		enemy.deacrease_health(player_damage)
	if $AnimatedSprite2D_Main.animation == "punch" and $AnimatedSprite2D_Main.frame == 4 and entered_puzzle:
		puzzle.get_parent().destroy()


func _on_timer_speed_timeout() -> void:
	var ui = get_node("/root/Main/CanvasLayer/MarginContainer")
	ui.hide_power_up(1)
	$AnimatedSprite2D_Speed.visible = false
	player_speed = 200.0

func _on_timer_power_timeout() -> void:
	var ui = get_node("/root/Main/CanvasLayer/MarginContainer")
	ui.hide_power_up(2)
	$AnimatedSprite2D_Power.visible = false
	player_damage = 1
