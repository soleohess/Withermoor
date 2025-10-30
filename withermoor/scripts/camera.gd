extends Camera2D

@onready var player = %Player
@export var offsetX: float = 0.0
@export var offsetY: float = -30.5
var target_position: Vector2
@export var following_speed: float = 0.15

func _physics_process(delta: float) -> void:
	target_position = Vector2((player.position.x + offsetX), (player.position.y + offsetY))
	position = Vector2(((1 - following_speed) * position.x) + (following_speed * target_position.x), ((1 - following_speed) * position.y) + (following_speed * target_position.y))
	
