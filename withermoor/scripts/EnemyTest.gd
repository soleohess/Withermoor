extends CharacterBody2D
class_name TestEnemy

@export var enemy_health: int
@export var has_gravity: bool = true
@export var enemy_contact_damage: int
@export var does_contact_damage: bool

func _ready() -> void:
	pass


func health():
	enemy_health = 100



#health
#
