extends CharacterBody2D
class_name enemy

#properties
@export var has_default_behavior: bool = true
@export var health: float = 6.0
@export var speed: float = 40.0
@export var does_contact_damage: bool = true
@export var contact_damage: float = 1.0
@export var has_gravity: bool = true
@export var is_alerted: bool = false
@export var is_damageable: bool = true
@export var dmg_flash_color: Color
var is_flashing: bool = false
@export var flash_color: Color = Color(1.0, 1.0, 1.0, 1.0)

#relevant child nodes
@export var sprite: AnimatedSprite2D
@export var ground_detector_left: CollisionShape2D
@export var ground_detector_right: CollisionShape2D
@export var wall_detector: CollisionShape2D

#other relevant nodes
@onready var tile_map_layer: TileMapLayer = $"../TileMapLayer"
@onready var sword_scene = %PlayerSword

#initial conditions
@onready var original_position: Vector2 = position
@export var direction: int = -1


func _ready() -> void:
	sprite.material.set_shader_parameter("filter_color", flash_color)
	sprite.material.set_shader_parameter("weight", 0.0)

func _physics_process(delta: float) -> void:
	if has_gravity and not is_on_floor():
		velocity += get_gravity() * (delta * 60)
	
	if has_default_behavior:
		default_behavior(delta)
		move_and_slide()
	
	if is_flashing:
		sprite.material.set_shader_parameter("weight", 0.9)
		is_flashing = false
	
	if sprite.material.get_shader_parameter("weight") > 0.0:
		sprite.material.set_shader_parameter("weight", sprite.material.get_shader_parameter("weight") - delta)

func _on_ground_detector_left_body_exited(body: Node2D) -> void:
	if has_default_behavior:
		if body == tile_map_layer:
			direction *= -1

func _on_ground_detector_right_body_exited(body: Node2D) -> void:
	if has_default_behavior:
		if body == tile_map_layer:
			direction *= -1

func _on_wall_detector_body_entered(body: Node2D) -> void:
	if has_default_behavior:
		if body == tile_map_layer:
			direction *= -1

func _on_enemy_hurtbox_area_entered(area: Area2D) -> void:
	if area == sword_scene:
		print("sword hit enemy")
		if is_damageable:
			take_damage(area.damage)

func default_behavior(_delta: float):
	if is_on_floor():
		velocity.x = speed * direction * (_delta * 60)

func take_damage(_damage: float) -> void:
	health -= _damage
	is_flashing = true
	print("enemy has " + str(health) + " health")
	if health <= 0.0:
		death()

func death() -> void:
	#the enemy dies
	print("enemy died")
	queue_free()
