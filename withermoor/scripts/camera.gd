extends Camera2D

@onready var player = %Player
@export var default_offsetX: float = 10.0
@export var default_offsetY: float = -30.5

var offsetX: float = default_offsetX
var offsetY: float = default_offsetY

var target_position: Vector2
@export var following_speed: float = 0.15
var is_following: bool = false

func _ready() -> void:
	position = player.position + Vector2(offsetX, offsetY)

func _physics_process(delta: float) -> void:
	offsetX = default_offsetX * player.direction
	target_position = Vector2((player.position.x + offsetX), (player.position.y + offsetY))
	position.x = ((1 - following_speed) * position.x) + (following_speed * target_position.x)
	
	if is_following:
		position.y = ((1 - following_speed) * position.y) + (following_speed * target_position.y)
	
	if abs(position.x - (player.position.x + offsetX)) < 0.1 and abs(position.y - (player.position.y + offsetY)) < 0.1:
		print("camera caught up to player")
		is_following = false


func _on_camera_box_area_exited(area: Area2D) -> void:
	is_following = true
