extends CharacterBody2D


var max_x_velocity = 150.0
var x_acceleration = max_x_velocity / 3
var startup_x_percent = 0.2
var jump_velocity = -375.0

var coyote_time: float = 0.1
var delay_jump_restriction: float = coyote_time
var can_jump: bool = false
var post_jump_timer: float = 1.0

#need to fix, don't know how to put keyboard inputs into an array
var left_inputs: Array = [KEY_LEFT, KEY_A]
var right_inputs: Array = [KEY_RIGHT, KEY_D]
var jump_inputs: Array = [KEY_SPACE]

var input_map_dict: Dictionary = {
	"left_inputs": [KEY_LEFT, KEY_A],
	"right_inputs": [KEY_RIGHT, KEY_D],
	"jump_inputs": [KEY_SPACE]
	}

#Test comment from my home computer.

#Another test comment from home...


func _ready() -> void:
	#InputMap.add_action("move_left")
	#InputMap.add_action("move_right")
	for input_dict_key in input_map_dict:
		InputMap.add_action(input_dict_key)
		if typeof(input_map_dict[input_dict_key]) == TYPE_ARRAY:
			for input_keycode in input_map_dict[input_dict_key]:
				var new_key = InputEventKey.new()
				new_key.keycode = input_keycode
				InputMap.action_add_event(input_dict_key, new_key)

#testing
func _input(event) -> void:
	print(event)
	if event is InputEventKey:
		print("Is key")
		print(OS.get_keycode_string(event.key_label))
		print(type_string(typeof(event)))
		print(type_string(typeof(OS.get_keycode_string(event.key_label))))

func _physics_process(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	handle_walk(delta)
	handle_jump(delta)
	move_and_slide()

func handle_walk(_delta):
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

func handle_jump(_delta):
	
	post_jump_timer += 0.01 * (_delta * 60)
	
	if Input.is_action_just_pressed("jump_inputs"):
		post_jump_timer = 0.0
	
	if post_jump_timer < 0.1 and can_jump:
		velocity.y = jump_velocity * (_delta * 60)
		can_jump = false
	
	if is_on_floor():
		delay_jump_restriction = coyote_time
		can_jump = true
	
	elif can_jump:
		delay_jump_restriction -= 0.01 * (_delta * 60)
		if delay_jump_restriction > 0.0001:
			can_jump = true
		
		else:
			can_jump = false
