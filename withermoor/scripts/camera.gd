extends Camera2D

@onready var player = %Player
@export var offsetX: float = 0.0
@export var offsetY: float = -30.5
var target_position: Vector2
@export var following_speed: float = 0.9

func _physics_process(delta: float) -> void:
	target_position = Vector2((player.position.x + offsetX), (player.position.y + offsetY))
	#position.x = (position.x - target_position.x) * following_speed
	#position.y = (position.y - target_position.y) * following_speed
	#print(Vector2(position.x, position.y))
	
	position.x = target_position.x
	position.y = target_position.y
