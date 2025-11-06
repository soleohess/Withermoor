extends CharacterBody2D
class_name enemy

@export var health: float = 1.0
@export var speed: float
@export var damage: float
@export var sprite: Sprite2D
@export var does_contact_damage: bool = false
@export var contact_damage_value: float = 0.0
@export var has_gravity: bool = true

func _physics_process(delta: float) -> void:
	if has_gravity and not is_on_floor():
		velocity += get_gravity() * delta
	
	move_and_slide()
