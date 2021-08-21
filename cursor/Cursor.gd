extends Area2D

var _latest_area: GridCell
var _dragged_area: GridCell
var _picked_occupant: CellObject

func _ready() -> void:
# warning-ignore:return_value_discarded
	connect("area_entered", self, "_area_entered")
# warning-ignore:return_value_discarded
	connect("area_exited", self, "_area_exited")


func _process(_delta: float) -> void:
	position = get_viewport().get_mouse_position()
	if Input.is_action_just_pressed("mouse_left") and _latest_area and _latest_area.occupant_can_be_moved():
		_pick_occupant()
		
	if Input.is_action_just_released("mouse_left") and _dragged_area:
		_drop_occupant()
	
	if _dragged_area:
		_picked_occupant.set_target(global_position, false)


func _drop_occupant() -> void:
	if not _latest_area\
		or _latest_area.occupant_blocks_drop():
		_dragged_area.set_occupant(_picked_occupant)
	else:
		_latest_area.set_occupant(_picked_occupant)
	if _latest_area:
		_latest_area.set_droppable_on_cursor(false)
	_picked_occupant.z_index -= 1000
	_picked_occupant = null
	_dragged_area = null


func _pick_occupant() -> void:
	_latest_area.set_droppable_on_cursor(true)
	_dragged_area = _latest_area
	_picked_occupant = _dragged_area.pick_occupant()
	_picked_occupant.z_index += 1000
	for cell in get_tree().get_nodes_in_group("grid_cell"):
		var on_enemy_side = _dragged_area.position.x < 0 and cell.position.x > 0 or\
		_dragged_area.position.x > 0 and cell.position.x < 0
		cell.set_on_enemy_side(on_enemy_side)


func _area_entered(area: Area2D) -> void:
	if area is GridCell:
		area.set_hovering(true)
		area.set_droppable_on_cursor(_dragged_area != null)
		_latest_area = area


func _area_exited(area: Area2D) -> void:
	if area is GridCell:
		area.set_hovering(false)
		area.set_droppable_on_cursor(false)
		if _latest_area == area:
			_latest_area = null
