tool
extends Node2D
class_name CellObject

var _direction: int = 1 setget set_direction
var _cell_pos: Vector2 = Vector2.ZERO setget set_cell_pos, get_cell_pos

export(bool) var can_be_moved
export(bool) var blocks_drop
export(bool) var is_large

onready var _tween = $Tween
onready var _sprite = $Sprite

func get_cell_pos() -> Vector2:
	return _cell_pos


func set_cell_pos(cell_pos: Vector2) -> void:
	_cell_pos = cell_pos


func set_direction(dir: int) -> void:
	_direction = dir
	_sprite.flip_h = dir < 0


func set_target(pos: Vector2, do_tween = true) -> void:
	if do_tween:
		_tween.interpolate_property(self, "global_position", global_position, pos, 0.5, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		_tween.start()
	else:
		global_position = pos


func hit(_hit_info: HitInfo) -> bool:
	# returns true if hit should continue moving
	return true


func _ready() -> void:
	pass

