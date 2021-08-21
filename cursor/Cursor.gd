extends Area2D

var _latest_area: GridCell
var _dragged_area: GridCell

func _ready() -> void:
	connect("area_entered", self, "_area_entered")
	connect("area_exited", self, "_area_exited")
	pass


func _process(delta: float) -> void:
	position = get_viewport().get_mouse_position()
	if Input.is_action_just_pressed("mouse_left") and _latest_area:
		_latest_area.modulate = Color.green
		_dragged_area = _latest_area
	if Input.is_action_just_released("mouse_left") and _dragged_area:
		if not _latest_area or _latest_area.is_occupied():
			#reset dragged area to previous state
			pass
		else:
			_latest_area.modulate = Color.green
		_dragged_area = null


func _area_entered(area: Area2D) -> void:
	if area is GridCell:
		area.set_highlighted(true)
		_latest_area = area


func _area_exited(area: Area2D) -> void:
	if area is GridCell:
		area.set_highlighted(false)
		if _latest_area == area:
			_latest_area = null
