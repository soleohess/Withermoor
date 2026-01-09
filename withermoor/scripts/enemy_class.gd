extends CharacterBody2D
class_name enemy

@export var has_default_behavior: bool = true
@export var health: float = 1.0
@export var speed: float = 40
@export var damage: float
@export var sprite: Sprite2D
@export var does_contact_damage: bool = false
@export var contact_damage_value: float = 0.0
@export var has_gravity: bool = true
@export var is_alerted: bool = false


@export var ground_detector_left: CollisionShape2D
@export var ground_detector_right: CollisionShape2D
@export var wall_detector: CollisionShape2D

@onready var tile_map_layer: TileMapLayer = $"../TileMapLayer"

@onready var original_position: Vector2 = position
@export var direction: int = -1


func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if has_gravity and not is_on_floor():
		velocity += get_gravity() * (delta * 60)
	
	if has_default_behavior:
		default_behavior(delta)
		move_and_slide()

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


func default_behavior(_delta: float):
	if is_on_floor():
		velocity.x = speed * direction * (_delta * 60)
