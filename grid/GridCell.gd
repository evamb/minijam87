tool
extends Area2D
class_name GridCell

enum OccupationState { EMPTY = 0, OCCUPIED = 1 }

export(OccupationState) var occupation_state = OccupationState.EMPTY

onready var collision_shape = $CollisionShape2D


func _ready() -> void:
	pass # Replace with function body.

#this should be replaced by proper occupants later
func set_occupant(state: int) -> void:
	occupation_state = state
	modulate = Color.gray if state == OccupationState.OCCUPIED else Color.white


func set_size(size: int) -> void:
	collision_shape.shape.set_extents(Vector2(size / 2.0, size / 2.0))


func set_highlighted(highlighted: bool) -> void:
	if highlighted:
		modulate = Color.blue if occupation_state == OccupationState.EMPTY else Color.red
	else:
		modulate = Color.gray if occupation_state == OccupationState.OCCUPIED else Color.white


func is_occupied() -> bool:
	return occupation_state == OccupationState.OCCUPIED
