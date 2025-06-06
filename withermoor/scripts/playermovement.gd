extends CharacterBody2D


const x_acceleration = 100.0
const max_x_velocity = 300.0
const jump_velocity = -375.0
#const MOVE_RIGHT = KEY_A

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#if Input.is_action_pressed("move_right"):
		#position.x += SPEED * delta;
		
	#Godot default movement
	#var direction := Input.get_axis("ui_left", "ui_right")
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT):
		if velocity.x >= max_x_velocity * -1:
			velocity.x += x_acceleration * -1
	if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT):
		if velocity.x <= max_x_velocity:
			velocity.x += x_acceleration

	move_and_slide()
