tool
extends Area2D
class_name GridCell

enum OccupationState { EMPTY = 0, OCCUPIED = 1 }

export(OccupationState) var occupation_state = OccupationState.EMPTY

onready var collision_shape = $CollisionShape2D


func _ready() -> void:
	pass # Replace with function body.


func set_size(size: int) -> void:
	collision_shape.shape.set_extents(Vector2(size / 2.0, size / 2.0))


func set_highlighted(highlighted: bool) -> void:
	if highlighted:
		modulate = Color.blue if occupation_state == OccupationState.EMPTY else Color.red
	else:
		modulate = Color.white
		
