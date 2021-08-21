tool
extends Area2D
class_name GridCell

enum States {
	NONE = 0,
	HOVERED = 1,
	HOVERED_WITH_CELL_OBJECT = 2,
}

const HIT_MARK_COLOR = Color.red
const DROP_BLOCKED_COLOR = Color.red
const CAN_PICK_COLOR = Color.blue
const CAN_DROP_COLOR = Color.green
const EMPTY_COLOR = Color.white

var _occupant: CellObject = null setget set_occupant
var _cell_pos: Vector2 = Vector2.ZERO setget set_cell_pos
var _state = States.NONE
var _hit_marks_enabled = false setget set_hit_mark_enabled
var _droppable_on_cursor = false setget set_droppable_on_cursor
var _hovering = false setget set_hovering
var _on_enemy_side = false setget set_on_enemy_side

onready var Obstacle = preload("res://cell_object/Obstacle.tscn")
onready var cell_object_map = {
	"stone": Obstacle,
	"tree": Obstacle,
	"crossbow": preload("res://cell_object/soldiers/Crossbow.tscn"),
	"sword": preload("res://cell_object/soldiers/Sword.tscn"),
	"bow": preload("res://cell_object/soldiers/Bow.tscn"),
}


func _ready() -> void:
	pass


func set_on_enemy_side(enabled: bool) -> void:
	_on_enemy_side = enabled
	_update_modulate()


func set_hovering(enabled: bool) -> void:
	_hovering = enabled
	if not enabled:
		_show_occupant_hit_marks(false)
	_update_modulate()


func set_droppable_on_cursor(enabled: bool) -> void:
	_droppable_on_cursor = enabled
	if enabled:
		_show_occupant_hit_marks(false)
	_update_modulate()


func set_hit_mark_enabled(enabled: bool) -> void:
	_hit_marks_enabled = enabled
	print("hit mark set to %s" % _hit_marks_enabled)
	_update_modulate()


func set_cell_pos(cell_pos: Vector2) -> void:
	_cell_pos = cell_pos


func set_occupant(cell_object: CellObject) -> void:
	_occupant = cell_object
	if cell_object != null:
		cell_object.set_target(global_position)
		cell_object.set_cell_pos(_cell_pos)


func create_occupant(occupant: String) -> void:
	var cell_object = cell_object_map[occupant].instance()
	get_parent().add_child(cell_object)
	cell_object.set_owner(get_tree().get_edited_scene_root())
	cell_object.set_direction(-1 if position.x > 0 else 1)
	set_occupant(cell_object)


func pick_occupant() -> CellObject:
	var picked = _occupant
	_occupant = null
	return picked


func set_size(size: int) -> void:
	#collision_shape.shape.set_extents(Vector2(size / 2.0, size / 2.0))
	scale = Vector2.ONE * size / 64.0 


func get_hit_cells() -> Array:
	if _occupant and _occupant.has_method("get_hit_cells"):
		return _occupant.get_hit_cells()
	else:
		return Array()


func occupant_can_be_moved() -> bool:
	return _occupant != null and _occupant.can_be_moved
	

func occupant_blocks_drop() -> bool:
	return _on_enemy_side or _occupant != null and _occupant.blocks_drop


func hit(source: CellObject) -> bool:
	modulate = Color.red
	# returns true if hit should continue moving
	return not _occupant or _occupant.hit(source)


func _update_modulate() -> void:
	match [_hit_marks_enabled, _droppable_on_cursor, _hovering, _on_enemy_side or occupant_blocks_drop()]:
		[true, _, _, _]: modulate = HIT_MARK_COLOR
		[false, false, true, _]:
			if occupant_can_be_moved():
				modulate = CAN_PICK_COLOR
				_show_occupant_hit_marks(true)
			else:
				modulate = EMPTY_COLOR
		[false, true, true, false]:
			modulate = CAN_DROP_COLOR
		[false, true, true, true]:
			modulate = DROP_BLOCKED_COLOR
		_: modulate = EMPTY_COLOR


func _show_occupant_hit_marks(enabled: bool) -> void:
	for cell in get_hit_cells():
		cell.set_hit_mark_enabled(enabled)
