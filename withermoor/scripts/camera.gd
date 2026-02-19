extends Camera2D

@onready var player = %Player
@onready var camera_box: CollisionShape2D = $"../Room/Player/camera_box/CollisionShape2D"

@export var default_offsetX: float = 20.0
@export var default_offsetY: float = -30.5

var offsetX: float = default_offsetX
var offsetY: float = default_offsetY

var target_position: Vector2
@export var following_speed: Vector2 = Vector2(0.08,0.05)
var is_following: bool = false

func _ready() -> void:
	position = player.position + Vector2(offsetX, offsetY)
	print(camera_box.shape.size)

func _physics_process(delta: float) -> void:
	offsetX = default_offsetX * player.facing
	target_position = Vector2((player.position.x + offsetX), (player.position.y + offsetY))
	position.x = ((1 - following_speed.x) * position.x) + (following_speed.x * target_position.x)
	position.y = ((1 - following_speed.y) * position.y) + (following_speed.y * target_position.y)
	
	if player.position.y - camera_box.shape.size.y > position.y:
		position.y = player.position.y - camera_box.shape.size.y
	elif player.position.y + camera_box.shape.size.y < position.y:
		position.y = player.position.y + camera_box.shape.size.y
	
	if player.position.x - camera_box.shape.size.x > position.x:
		position.x = player.position.x - camera_box.shape.size.x
	elif player.position.x + camera_box.shape.size.x < position.x:
		position.x = player.position.x + camera_box.shape.size.x
	
	
	#if abs(position.x - (player.position.x + offsetX)) < 0.1 and abs(position.y - (player.position.y + offsetY)) < 0.1:
		#print("camera caught up to player")
		#is_following = false


func _on_camera_box_area_exited(area: Area2D) -> void:
	is_following = true

func _on_camera_box_area_entered(area: Area2D) -> void:
	is_following = false
