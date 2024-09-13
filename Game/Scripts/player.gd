extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -300.0

var is_facing_right = true
var wait_for_anim_end = false
var is_jumping = false
var is_crouching = false # ras le cul, j'aimerais apprendre les anim tree mais tant pis
var is_running = false # si quelqu'un vois ce code je n'ai plus aucune crédibilitée dans l'univers
var is_punching = false
var direction

func _physics_process(delta: float) -> void:
	direction = Input.get_axis("ui_left", "ui_right")
	is_facing_right = false if direction == -1 else true
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		if !is_jumping:
			play_anim("fall", !is_facing_right)
	else:
		# The Movement
		if direction and (!is_crouching and !is_punching): # Crouch as the priority over movement
			velocity.x = direction * SPEED
			play_anim("run", !is_facing_right)
			is_running = true
		else:
			# If the player does nothing, idle
			if !is_crouching and !is_punching:
				velocity.x = move_toward(velocity.x, 0, SPEED)
				play_anim("idle", !is_facing_right)
				is_punching = false
				is_crouching = false
			
		# Handle jump.
		if Input.is_action_just_pressed("ui_accept"):
			velocity.y = JUMP_VELOCITY
			play_anim("jump", !is_facing_right)
			is_jumping = true
			is_punching = false
		# Handle the punch
		if Input.is_action_just_pressed("ui_select"):
			play_anim("punch", !is_facing_right)
			is_punching = true
			velocity.x = 0
		# Handle crouching and unchrouching
		if Input.is_action_just_pressed("ui_down"):
			is_running = false
			play_anim("crouch", !is_facing_right)
			is_crouching = true
			velocity.x = 0
		elif Input.is_action_just_released("ui_down"):
			play_anim("crouch", !is_facing_right, false)
			is_crouching = false
			
		is_jumping = velocity.y < 0
		if $AnimatedSprite2D.animation == "punch" and $AnimatedSprite2D.frame_progress == 1:
			print("OIA")
			is_punching = false
	print($AnimatedSprite2D.animation)
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	move_and_slide()

func play_anim(anim_name : String, face_direction : bool, play_forward: bool = true):
	$AnimatedSprite2D.animation = anim_name
	$AnimatedSprite2D.flip_h = face_direction
	if play_forward:
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.play_backwards()
