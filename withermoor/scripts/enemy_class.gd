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

@export var original_position: Vector2
@export var ground_detector: CollisionShape2D

@onready var tile_map_layer: TileMapLayer = $"../TileMapLayer"

func _ready() -> void:
	original_position = position
	speed = 30
	velocity.x = -speed


func _physics_process(delta: float) -> void:
	#print(position)
	if has_gravity and not is_on_floor():
		velocity += get_gravity() * delta
	
	move_and_slide()


func _on_ground_detector_body_entered(body: Node2D) -> void:
	print(body)
	if body == tile_map_layer:
		print("enemy collided with tile_map_layer")
		print(ground_detector)
		if ground_detector:
			print(tile_map_layer.local_to_map(ground_detector.position))
