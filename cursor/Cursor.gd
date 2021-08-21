extends Area2D

var _latest_area: GridCell
var _dragged_area: GridCell
var _picked_occupant: CellObject
var _picked_parent: Node2D

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
		_picked_parent = _picked_occupant.get_parent()
		_picked_parent.remove_child(_picked_occupant)
		add_child(_picked_occupant)
		_picked_occupant.position = Vector2.ZERO
	if Input.is_action_just_released("mouse_left") and _dragged_area:
		remove_child(_picked_occupant)
		_picked_parent.add_child(_picked_occupant)
		if not _latest_area or _latest_area.occupant_blocks_drop():
			_dragged_area.set_occupant(_picked_occupant)
		else:
			_latest_area.set_occupant(_picked_occupant)
		_picked_occupant = null
		_dragged_area = null
	if _dragged_area and _latest_area and not _latest_area.occupant_blocks_drop():
		_latest_area.modulate = Color.green


func _area_entered(area: Area2D) -> void:
	if area is GridCell:
		area.set_highlighted(true)
		_latest_area = area


func _area_exited(area: Area2D) -> void:
	if area is GridCell:
		area.set_highlighted(false)
		if _latest_area == area:
			_latest_area = null
