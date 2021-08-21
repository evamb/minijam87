tool
extends Area2D
class_name GridCell

var _occupant: CellObject = null setget set_occupant

onready var Soldier = preload("res://cell_object/Soldier.tscn")
onready var Obstacle = preload("res://cell_object/Obstacle.tscn")
onready var cell_object_map = {
	"stone": Obstacle,
	"tree": Obstacle,
	"crossbow": Soldier,
	"sword": Soldier,
	"bow": Soldier,
}


func _ready() -> void:
	pass


func set_occupant(cell_object: CellObject) -> void:
	_occupant = cell_object
	if cell_object != null:
		cell_object.set_target(global_position)


func create_occupant(occupant: String) -> void:
	var cell_object = cell_object_map[occupant].instance()
	get_parent().add_child(cell_object)
	cell_object.set_owner(get_tree().get_edited_scene_root())
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
