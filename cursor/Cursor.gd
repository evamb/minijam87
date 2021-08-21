extends Area2D

var _latest_area: GridCell
var _dragged_area: GridCell
var _picked_occupant: CellObject

func _ready() -> void:
	connect("area_entered", self, "_area_entered")
	connect("area_exited", self, "_area_exited")
	pass


func _process(delta: float) -> void:
	position = get_viewport().get_mouse_position()
	if Input.is_action_just_pressed("mouse_left") and _latest_area and _latest_area.occupant_can_be_moved():
		_latest_area.modulate = Color.green
		_dragged_area = _latest_area
		_picked_occupant = _dragged_area.pick_occupant()
	if Input.is_action_just_released("mouse_left") and _dragged_area:
		if not _latest_area\
			or _latest_area.occupant_blocks_drop()\
			or _latest_is_on_other_side():
			_dragged_area.set_occupant(_picked_occupant)
		else:
			_latest_area.set_occupant(_picked_occupant)
		if _latest_area:
			_latest_area.modulate = Color.white
		_dragged_area.modulate = Color.white
		_picked_occupant = null
		_dragged_area = null
	if _dragged_area:
		_picked_occupant.set_target(global_position, false)
		if _latest_area and\
			not _latest_area.occupant_blocks_drop():
				_latest_area.modulate = Color.red if _latest_is_on_other_side() else Color.green
			


func _latest_is_on_other_side() -> bool:
	return _dragged_area.position.x < 0 and _latest_area.position.x > 0 or\
		_dragged_area.position.x > 0 and _latest_area.position.x < 0


func _area_entered(area: Area2D) -> void:
	if area is GridCell:
		area.set_highlighted(true)
		_latest_area = area


func _area_exited(area: Area2D) -> void:
	if area is GridCell:
		area.set_highlighted(false)
		if _latest_area == area:
			_latest_area = null
