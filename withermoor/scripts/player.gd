extends CharacterBody2D

#movement
var max_x_velocity: float = 150.0
var x_acceleration: float = max_x_velocity / 3
var startup_x_percent = 0.2
var jump_velocity: float = -375.0
var direction: int = 0
var facing: int = 1

#jump input stuff
var min_jump_time: float = 0.0
var jump_release_rate: float = 1.5
const coyote_time: float = 0.1
const jump_input_buffer: float = 0.1
var delay_jump_restriction: float = coyote_time
var can_jump: bool = false
var jump_input_timer: float = 1.0
var timer_after_jump: float = 0.0

#health and damage
var health: float = 10.0
var damage_zones: Array = []
var is_invincible: bool = false
var iframe_set_time: float = 1.3
var iframe_timer: float = 0.0

#sword stuff
var sword_damage: float = 2.0
var sword_offset: Vector2 = Vector2(5.0, -16.0)



#h(t) = 1/2 at^2 + v0 t
#h_max = h(-v0/a)

var input_map_dict: Dictionary = {
	"left_inputs": [KEY_LEFT],
	"right_inputs": [KEY_RIGHT],
	"jump_inputs": [KEY_X, KEY_SPACE],
	"sword_inputs": [KEY_C],
	"dash_inputs": [KEY_Z]
	}


func _ready() -> void:
	configure_inputs(input_map_dict)


func _physics_process(delta: float) -> void:
	#Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if iframe_timer >= -1:
		iframe_timer -= delta
	if iframe_timer <= 0.0:
		is_invincible = false
	
	if damage_zones and not is_invincible:
			if damage_zones[0] is enemy:
				take_damage(damage_zones[0].damage)
			else:
				push_warning("damage_zones contains non enemy object at index zero")
				push_warning("damage_zones: " + str(damage_zones))
				push_warning("index zero will now be erased")
				damage_zones.remove_at(0)
	
	handle_walk(delta)
	handle_jump(delta)
	move_and_slide()


func _on_enemy_check_body_entered(body: Node2D) -> void:
	print("The enemy_check collided with:")
	print(body)
	if not is_invincible and body is enemy:
		damage_zones.append(body)

func _on_enemy_check_body_exited(body: Node2D) -> void:
	if body is enemy:
		while damage_zones.has(body):
			damage_zones.erase(body)

func take_damage(_damage):
	iframe_timer = iframe_set_time
	is_invincible = true
	health -= _damage
	print("Health is now at:")
	print(health)
	if health <= 0.0:
		print("You died!")

func configure_inputs(_input_map: Dictionary) -> void:
	for input_dict_key in _input_map:
		InputMap.add_action(input_dict_key)
		if typeof(input_map_dict[input_dict_key]) == TYPE_ARRAY:
			for input_keycode in input_map_dict[input_dict_key]:
				var new_key = InputEventKey.new()
				new_key.keycode = input_keycode
				InputMap.action_add_event(input_dict_key, new_key)

func handle_walk(_delta: float) -> bool:
	#Note: should consider the difference between key and physical_key
	
	if Input.is_action_pressed("left_inputs") and not Input.is_action_pressed("right_inputs"):
		#left
		direction = -1
	elif Input.is_action_pressed("right_inputs") and not Input.is_action_pressed("left_inputs"):
		#right
		direction = 1
	else:
		#neither
		direction = 0
	
	if direction != 0:
		#facing is only for animation, direction is for movement
		facing = direction
		
		#walk
		if abs(velocity.x) <= max_x_velocity * startup_x_percent * (_delta * 60):
			#start walking
			velocity.x = max_x_velocity * startup_x_percent * direction * (_delta * 60)
		if abs(velocity.x) <= max_x_velocity * (_delta * 60):
			#speed up
			velocity.x += x_acceleration * direction * (_delta * 60)
		else:
			#keep walking
			velocity.x = max_x_velocity * direction * (_delta * 60)
	else:
		#stop
		velocity.x /= 1.5 * (_delta * 60)
	
	return (Input.is_action_pressed("left_inputs") or Input.is_action_pressed("right_inputs"))

func handle_jump(_delta: float) -> bool:
	
	jump_input_timer += _delta
	timer_after_jump += _delta
	
	
	if Input.is_action_just_pressed("jump_inputs"):
		#queue the jump
		jump_input_timer = 0.0
	
	if jump_input_timer < jump_input_buffer and can_jump:
		#if you just pressed jump (with input buffering) and can jump
		velocity.y = jump_velocity * (_delta * 60)
		timer_after_jump = 0.0
		can_jump = false
	
	if timer_after_jump > min_jump_time and velocity.y < 0.0 and not Input.is_action_pressed("jump_inputs"):
		#this slows the jump if input is released before zenith is reached
		#gravity is handled in _phisics_process()
		velocity.y = velocity.y / jump_release_rate
	
	if is_on_floor():
		if not can_jump:
			print(timer_after_jump)
		delay_jump_restriction = coyote_time
		can_jump = true
	
	elif can_jump:
		#coyote timer
		delay_jump_restriction -= _delta
		
		if delay_jump_restriction > 0.0001:
			can_jump = true
		
		else:
			can_jump = false
	
	return Input.is_action_just_pressed("jump_inputs")

func handle_sword(_delta:float) -> bool:
	if Input.is_action_just_pressed("sword_inputs"):
		sword_attack()
	return Input.is_action_just_pressed("sword_inputs")

func sword_attack() -> void:
	pass
