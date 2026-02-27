extends enemy

@export var is_underground: bool = true

func _physics_process(delta: float) -> void:
	mole_behavior(delta)

func mole_behavior(_delta: float) -> void:
	if (is_on_floor()):
		default_behavior(_delta)
	
