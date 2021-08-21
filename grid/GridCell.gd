tool
extends Area2D
class_name GridCell

var _occupant: CellObject = null setget set_occupant
var _cell_pos: Vector2 = Vector2.ZERO setget set_cell_pos

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


func set_highlighted(highlighted: bool) -> void:
	if highlighted and _occupant != null and _occupant.can_be_moved:
		modulate = Color.blue
	else:
		modulate = Color.white


func occupant_can_be_moved() -> bool:
	return _occupant != null and _occupant.can_be_moved
	

func occupant_blocks_drop() -> bool:
	return _occupant != null and _occupant.blocks_drop


func hit(source: CellObject) -> bool:
	modulate = Color.red
	# returns true if hit should continue moving
	return not _occupant or _occupant.hit(source)
