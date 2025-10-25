extends CharacterBody2D


var max_x_velocity = 150.0
var x_acceleration = max_x_velocity / 3
var startup_x_percent = 0.2
var jump_velocity = -375.0

var min_jump_time: float = 0.04
var jump_release_rate: float = 1.5

var coyote_time: float = 0.06
var delay_jump_restriction: float = coyote_time
var can_jump: bool = false
var jump_input_timer: float = 1.0

var jump_debug_timer: float = 0.0

#h(t) = 1/2 at^2 + v0 t
#h_max = h(-v0/a)

var input_map_dict: Dictionary = {
	"left_inputs": [KEY_LEFT, KEY_A],
	"right_inputs": [KEY_RIGHT, KEY_D],
	"jump_inputs": [KEY_SPACE]
	}

#Test comment from my home computer.

#Another test comment from home...


func _ready() -> void:
	configure_inputs(input_map_dict)

#testing
#func _input(event) -> void:
	#print(event)
	#if event is InputEventKey:
		#print("Is key")
		#print(OS.get_keycode_string(event.key_label))
		#print(type_string(typeof(event)))
		#print(type_string(typeof(OS.get_keycode_string(event.key_label))))

func _physics_process(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	
	handle_walk(delta)
	handle_variable_jump(delta)
	move_and_slide()

func configure_inputs(_input_map: Dictionary):
	for input_dict_key in _input_map:
		InputMap.add_action(input_dict_key)
		if typeof(input_map_dict[input_dict_key]) == TYPE_ARRAY:
			for input_keycode in input_map_dict[input_dict_key]:
				var new_key = InputEventKey.new()
				new_key.keycode = input_keycode
				InputMap.action_add_event(input_dict_key, new_key)

func handle_walk(_delta) -> bool:
	#Note: could change to Input.is_physical_key_pressed()
	
	#left walking
	if Input.is_action_pressed("left_inputs"):
		if velocity.x >= max_x_velocity * startup_x_percent * -1:
			velocity.x = max_x_velocity * startup_x_percent * -1
		if velocity.x >= max_x_velocity * -1:
			velocity.x += x_acceleration * (_delta * 60) * -1
		else:
			velocity.x = max_x_velocity * (_delta * 60) * -1
	
	#right walking
	if Input.is_action_pressed("right_inputs"):
		if velocity.x <= max_x_velocity * startup_x_percent:
			velocity.x = max_x_velocity * startup_x_percent
		if velocity.x <= max_x_velocity:
			velocity.x += x_acceleration * (_delta * 60)
		else:
			velocity.x = max_x_velocity * (_delta * 60)
	
	#deceleration here
	if not (Input.is_action_pressed("left_inputs") or Input.is_action_pressed("right_inputs")):
		velocity.x /= 1.5 * (_delta * 60)
	
	return (Input.is_action_pressed("left_inputs") or Input.is_action_pressed("right_inputs"))

func handle_jump(_delta) -> bool:
	
	jump_input_timer += 0.01 * (_delta * 60)
	
	if Input.is_action_just_pressed("jump_inputs"):
		#queue the jump
		jump_input_timer = 0.0
	
	if jump_input_timer < 0.1 and can_jump:
		#if you just pressed jump (with input buffering) and can jump
		velocity.y = jump_velocity * (_delta * 60)
		can_jump = false
	
	if is_on_floor():
		delay_jump_restriction = coyote_time
		can_jump = true
	
	elif can_jump:
		#coyote timer
		delay_jump_restriction -= 0.01 * (_delta * 60)
		
		if delay_jump_restriction > 0.0001:
			can_jump = true
		
		else:
			can_jump = false
	
	return Input.is_action_just_pressed("jump_inputs")


func handle_variable_jump(_delta) -> bool:
	
	jump_input_timer += _delta
	jump_debug_timer += _delta
	
	
	if Input.is_action_just_pressed("jump_inputs"):
		#queue the jump
		jump_input_timer = 0.0
	
	if jump_input_timer < 0.1 and can_jump:
		#if you just pressed jump (with input buffering) and can jump
		velocity.y = jump_velocity * (_delta * 60)
		jump_debug_timer = 0.0
		can_jump = false
	
	if jump_debug_timer > min_jump_time and velocity.y < 0.0 and not Input.is_action_pressed("jump_inputs"):
		velocity.y = velocity.y / jump_release_rate
	
	if is_on_floor():
		if not can_jump:
			print(jump_debug_timer)
		delay_jump_restriction = coyote_time
		can_jump = true
	
	elif can_jump:
		#coyote timer
		delay_jump_restriction -= 0.01 * (_delta * 60)
		
		if delay_jump_restriction > 0.0001:
			can_jump = true
		
		else:
			can_jump = false
	
	return Input.is_action_just_pressed("jump_inputs")
