extends CharacterBody2D


const max_x_velocity = 150.0
const x_acceleration = max_x_velocity / 3
const jump_velocity = -375.0
#const MOVE_RIGHT = KEY_A

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
 
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity * (delta * 60)
	
	if Input.is_action_just_pressed("jump"):
		print("jump")
	
	#left walking
	if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT):
		if velocity.x >= max_x_velocity * -1:
			velocity.x += x_acceleration * (delta * 60) * -1
		else:
			velocity.x = max_x_velocity * (delta * 60) * -1
	#right walking
	if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT):
		if velocity.x <= max_x_velocity:
			velocity.x += x_acceleration * (delta * 60)
		else:
			velocity.x = max_x_velocity * (delta * 60)
	
	#deceleration here
	if not (Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT) or Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT)):
		velocity.x /= 1.5 * (delta * 60)

	move_and_slide()
