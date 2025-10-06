extends CharacterBody2D


const max_x_velocity = 150.0
const x_acceleration = max_x_velocity / 3
const jump_velocity = -375.0

#need to fix, don't know how to put keyboard inputs into an array
var left_inputs: Array = [KEY_LEFT, KEY_A]
var right_inputs: Array = [KEY_RIGHT, KEY_D]
var jump_inputs: Array = [KEY_SPACE]

#Test comment from my home computer.

#Another test comment from home...


func _ready() -> void:
	InputMap.add_action("move_left")
	InputMap.add_action("move_right")
	for input_keycode in left_inputs:
		var new_key = InputEventKey.new()
		new_key.keycode = input_keycode
		InputMap.action_add_event("move_left", new_key)
	for input_keycode in right_inputs:
		var new_key = InputEventKey.new()
		new_key.keycode = input_keycode
		InputMap.action_add_event("move_right", new_key)
	#configure jump

#testing
func _input(event) -> void:
	print(event)
	if event is InputEventKey:
		print("Is key")
		print(OS.get_keycode_string(event.key_label))
		print(type_string(typeof(event)))
		print(type_string(typeof(OS.get_keycode_string(event.key_label))))

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
 
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity * (delta * 60)
	
	#if Input.is_action_just_pressed("jump"):
	#	print("jump")
	
	#Note: should probably change to Input.is_physical_key_pressed()
	
	#left walking
	if Input.is_action_pressed("move_left"):
		if velocity.x >= max_x_velocity * -1:
			velocity.x += x_acceleration * (delta * 60) * -1
		else:
			velocity.x = max_x_velocity * (delta * 60) * -1
	
	#right walking
	if Input.is_action_pressed("move_right"):
		if velocity.x <= max_x_velocity:
			velocity.x += x_acceleration * (delta * 60)
		else:
			velocity.x = max_x_velocity * (delta * 60)
	
	#deceleration here
	if not (Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")):
		velocity.x /= 1.5 * (delta * 60)

	move_and_slide()
