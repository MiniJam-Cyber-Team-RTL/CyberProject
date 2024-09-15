extends CharacterBody2D

const JUMP_VELOCITY = -500.0
const POWER_UP_TIMER = 30

var is_facing_right = true
var wait_for_anim_end = false
var is_jumping = false
var is_crouching = false # ras le cul, j'aimerais apprendre les anim tree mais tant pis
var is_running = false # si quelqu'un vois ce code je n'ai plus aucune crédibilitée dans l'univers
var is_punching = false

var player_speed = 200.0
var player_life = 5;
var player_damage = 1;

var direction
func _ready():
	$AnimatedSprite2D_Power.visible = false
	$AnimatedSprite2D_Speed.visible = false
	$"MusicPlayer".play()
	$Area2D/CollisionShape2D_Right.disabled = true
	$Area2D/CollisionShape2D_Left.disabled = true
	
func _physics_process(delta: float) -> void:
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
<<<<<<< HEAD
	print($AnimatedSprite2D_Main.animation)
		
	if !$"MusicPlayer".is_playing():
		$"MusicPlayer".play()
		
=======
	print(player_life, "et en dmg ", player_damage)
	
>>>>>>> pickups
	move_and_slide()
	
	
func change_collision(collision1 : bool, collision2: bool):
	$CollisionShape2D.disabled = !collision1
	$CollisionShape2D_Crouch.disabled = !collision2

func play_anim(anim_name : String, face_direction : bool = true, play_forward: bool = true):
	$AnimatedSprite2D_Main.animation = anim_name
	$AnimatedSprite2D_Power.animation = anim_name + "_red"
	$AnimatedSprite2D_Speed.animation = anim_name + "_yellow"
	$AnimatedSprite2D_Main.flip_h = face_direction
	$AnimatedSprite2D_Power.flip_h = face_direction
	$AnimatedSprite2D_Speed.flip_h = face_direction
	$AnimatedSprite2D_Main.centered = true
	
	if play_forward:
		$AnimatedSprite2D_Main.play()
		$AnimatedSprite2D_Power.play()
		$AnimatedSprite2D_Speed.play()
	else:
		$AnimatedSprite2D_Main.play_backwards()
		$AnimatedSprite2D_Power.play_backwards()
		$AnimatedSprite2D_Speed.play_backwards()
		
	if anim_name == "punch":
		if face_direction:
			$Area2D/CollisionShape2D_Left.disabled = false
		else: 
			$Area2D/CollisionShape2D_Right.disabled = false
	else:
		$Area2D/CollisionShape2D_Left.disabled = true
		$Area2D/CollisionShape2D_Right.disabled = true

func take_damage(damage: int):
	player_life -= damage
	if player_life < 1:
		play_anim("die")
		# TODO do something after the death
	else:
		play_anim("hurt")
		
func pickup_power_up(type):
	$Timer.wait_time = POWER_UP_TIMER
	$Timer.one_shot = true
	# Power power-up
	if type == 1:
		player_damage += 1
		$AnimatedSprite2D_Power.visible = true
		$Timer.start()
	elif type == 2:
		player_speed = player_speed * 2
		$AnimatedSprite2D_Speed.visible = true
		$Timer.start()
	else:
		player_life += 1
	
func _on_timer_timeout() -> void:
	$AnimatedSprite2D_Power.visible = false
	$AnimatedSprite2D_Speed.visible = false
	player_speed = 100.0
	player_damage = 1

#sacré singerie
func player():
	pass

func _on_area_2d_area_entered(area: Area2D) -> void:
	if is_punching:
		var Boxes = get_tree().get_nodes_in_group("Box")
		if Boxes != null:
			var Box = Boxes[0]
			Box.destroy()
