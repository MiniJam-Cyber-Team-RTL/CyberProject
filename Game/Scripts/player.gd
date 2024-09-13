extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -300.0

var is_facing_right = true

func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("ui_left", "ui_right")
	is_facing_right = false if direction == -1 else true
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	else:
		if direction:
			velocity.x = direction * SPEED
			$AnimatedSprite2D.animation = "run"
			$AnimatedSprite2D.flip_h = !is_facing_right
			$AnimatedSprite2D.play()
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			$AnimatedSprite2D.animation = "idle"
			$AnimatedSprite2D.play()
			# Handle jump.
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			$AnimatedSprite2D.animation = "jump"
			$AnimatedSprite2D.flip_h = !is_facing_right
			$AnimatedSprite2D.play()
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	move_and_slide()
