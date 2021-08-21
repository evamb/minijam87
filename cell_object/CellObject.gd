tool
extends Node2D
class_name CellObject

export(bool) var can_be_moved
export(bool) var blocks_drop

onready var _tween = $Tween

func set_target(pos: Vector2, do_tween = true) -> void:
	if do_tween:
		_tween.interpolate_property(self, "global_position", global_position, pos, 0.5, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		_tween.start()
	else:
		global_position = pos
	
func _ready() -> void:
	pass

