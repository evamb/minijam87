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
var _cell_pos: Vector2 = Vector2.ZERO setget set_cell_pos, get_cell_pos
var _state = States.NONE
var _hit_marks_enabled = false setget set_hit_mark_enabled
var _droppable_on_cursor = false setget set_droppable_on_cursor
var _hovering = false setget set_hovering
var _on_enemy_side = false setget set_on_enemy_side
var _exceeds_mana = false setget set_exceeds_mana
var _look_through = false setget set_look_through

onready var Obstacle = preload("res://cell_object/Obstacle.tscn")
onready var cell_object_map = {
	"rock": preload("res://cell_object/obstacles/Rock.tscn"),
	"tree": preload("res://cell_object/obstacles/Tree.tscn"),
	"crossbow": preload("res://cell_object/soldiers/Crossbow.tscn"),
	"sword": preload("res://cell_object/soldiers/Sword.tscn"),
	"bow": preload("res://cell_object/soldiers/Bow.tscn"),
}
onready var _tween = $Tween


func _ready() -> void:
	modulate.a = 0


func set_exceeds_mana(enabled: bool) -> void:
	_exceeds_mana = enabled
	_update_modulate()


func set_look_through(enabled: bool) -> void:
	_look_through = enabled;
	_update_modulate()


func set_on_enemy_side(enabled: bool) -> void:
	_on_enemy_side = enabled
	_update_modulate()


func set_hovering(enabled: bool) -> void:
	_hovering = enabled
	if not enabled:
		_show_occupant_hit_marks(false)
	var lower_cell = get_parent().get_cell(_cell_pos + Vector2.DOWN)
	if lower_cell:
		lower_cell.set_look_through(enabled)
	_update_modulate()


func set_droppable_on_cursor(enabled: bool) -> void:
	_droppable_on_cursor = enabled
	if enabled:
		_show_occupant_hit_marks(false)
	_update_modulate()


func set_hit_mark_enabled(enabled: bool) -> void:
	_hit_marks_enabled = enabled
	_update_modulate()


func set_cell_pos(cell_pos: Vector2) -> void:
	_cell_pos = cell_pos


func get_cell_pos() -> Vector2:
	return _cell_pos


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
	cell_object.global_position = global_position
	set_occupant(cell_object)
	if cell_object.has_method("spawn"):
		yield(cell_object.spawn(), "completed")
	else:
		yield(get_tree(), "idle_frame")


func pick_occupant() -> Soldier:
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


func hit(hit_info: HitInfo) -> bool:
	modulate = Color.red
	# returns true if hit should continue moving
	return not _occupant or _occupant.hit(hit_info)


func _update_modulate() -> void:
	var drop_forbidden = _exceeds_mana or _on_enemy_side or occupant_blocks_drop()
	var modulate_color = Color.white
	match [_hit_marks_enabled, _droppable_on_cursor, _hovering, drop_forbidden]:
		[true, _, _, _]: modulate_color = HIT_MARK_COLOR
		[false, false, true, _]:
			if occupant_can_be_moved():
				modulate_color = CAN_PICK_COLOR
				_show_occupant_hit_marks(true)
			else:
				modulate_color = EMPTY_COLOR
		[false, true, true, false]:
			modulate_color = CAN_DROP_COLOR
		[false, true, true, true]:
			modulate_color = DROP_BLOCKED_COLOR
		_: modulate_color = EMPTY_COLOR
	if _occupant and _occupant.is_large:
		_tween.interpolate_property(_occupant,
			"modulate",
			null,
			Color(1, 1, 1, 0.3) if _look_through else Color.white, 0.25)
	if modulate_color != EMPTY_COLOR:
		modulate_color.a = 0.8
	else:
		modulate_color.a = 0
	_tween.interpolate_property(self, "modulate", null, modulate_color, 0.15)
	_tween.start()


func _show_occupant_hit_marks(enabled: bool) -> void:
	for cell in get_hit_cells():
		cell.set_hit_mark_enabled(enabled)
