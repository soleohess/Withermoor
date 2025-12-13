extends CharacterBody2D
class_name enemy

@export var health: float = 1.0
@export var speed: float
@export var damage: float
@export var sprite: Sprite2D
@export var does_contact_damage: bool = false
@export var contact_damage_value: float = 0.0
@export var has_gravity: bool = true
@export var is_alerted: bool = false

@export var max_x: float
@export var min_x: float
@export var original_position: Vector2

@onready var tile_map_layer: TileMapLayer = $"../TileMapLayer"

func _ready() -> void:
	original_position = position
	speed = 30
	max_x = 150
	min_x = 50
	#velocity.x = -speed
	print(tile_map_layer.tile_map_data)

func _physics_process(delta: float) -> void:
	#print(position)
	if has_gravity and not is_on_floor():
		velocity += get_gravity() * delta
		
	
	#if is_on_floor() and position.x >= max_x:
		#velocity.x = -speed
	#elif is_on_floor() and position.x <= min_x:
		#velocity.x = speed
	move_and_slide()




func _on_ground_detector_body_entered(body: Node2D) -> void:
	pass
