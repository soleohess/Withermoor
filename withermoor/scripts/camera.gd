extends Camera2D

@onready var player = %Player
@export var offsetX: float = 0.0
@export var offsetY: float = -30.5
var target_position: Vector2
@export var following_speed: float = 0.15
var is_following: bool = false

func _ready() -> void:
	position = player.position

func _physics_process(delta: float) -> void:
	if is_following:
		target_position = Vector2((player.position.x + offsetX), (player.position.y + offsetY))
		position = Vector2(((1 - following_speed) * position.x) + (following_speed * target_position.x), ((1 - following_speed) * position.y) + (following_speed * target_position.y))
	
	if abs(position.x - (player.position.x + offsetX)) < 0.1 and abs(position.y - (player.position.y + offsetY)) < 0.1:
		print("camera caught up to player")
		is_following = false


func _on_camera_box_area_exited(area: Area2D) -> void:
	is_following = true
