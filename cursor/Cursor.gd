extends Area2D

signal can_undo
signal mana_changed
signal mana_used_changed
signal failed
signal succeeded
signal picked
signal dropped
signal soldier_hovered

export(int) var level = 0
export(int) var start_mana = 10

var _latest_area: GridCell
var _dragged_area: GridCell
var _picked_occupant: CellObject
var _undo_stack: Array
var _mana = 10
var _used_mana = 0
var _soldier_got_hit = false


func _ready() -> void:
# warning-ignore:return_value_discarded
	connect("area_entered", self, "_area_entered")
# warning-ignore:return_value_discarded
	connect("area_exited", self, "_area_exited")
	yield(get_tree(), "idle_frame")
	_mana = start_mana
	emit_signal("mana_changed", _mana)
	monitoring = false


func _process(_delta: float) -> void:
	position = get_viewport().get_mouse_position()
	if Input.is_action_just_pressed("mouse_left") and _latest_area and _latest_area.occupant_can_be_moved():
		_pick_occupant()
		
	if Input.is_action_just_released("mouse_left") and _dragged_area:
		_drop_occupant()
		
	if Input.is_action_just_pressed("ui_cancel"):
		_undo()
	
	if _dragged_area:
		_picked_occupant.set_target(global_position, false)


func _notify_mana(mana: int) -> void:
	emit_signal("mana_changed", mana)


func _change_mana(delta: int) -> void:
	_mana += delta
	_used_mana -= delta
	emit_signal("mana_used_changed", _used_mana)


func _undo() -> void:
	_reset_scene_objects()
	var fromTo = _undo_stack.pop_back()
	if fromTo:
		var occupant = fromTo[1].pick_occupant()
		fromTo[0].set_occupant(occupant)
		_change_mana(_get_mana_cost(fromTo[0], fromTo[1]))
		_notify_mana(_mana)
	
	if _undo_stack.size() == 0:
		emit_signal("can_undo", false)


func _get_mana_cost(a: GridCell, b: GridCell) -> int:
	return int(a.get_cell_pos().distance_to(b.get_cell_pos()))


func _drop_occupant() -> void:
	var cost = 0
	if _dragged_area and _latest_area:
		cost = _get_mana_cost(_dragged_area, _latest_area)
	if not _latest_area\
		or _latest_area.occupant_blocks_drop()\
		or cost > _mana:
		_dragged_area.set_occupant(_picked_occupant)
	else:
		_latest_area.set_occupant(_picked_occupant)
		print("instance ids: %s, %s" % [_dragged_area.get_instance_id(), _latest_area.get_instance_id()])
		if _dragged_area != _latest_area:
			_undo_stack.append([_dragged_area, _latest_area])
			emit_signal("can_undo", true)
		_change_mana(-cost)
	_notify_mana(_mana)
	if _latest_area:
		_latest_area.set_droppable_on_cursor(false)
	_picked_occupant.z_index -= 1000
	_picked_occupant.set_picked(false)
	_picked_occupant = null
	_dragged_area = null
	emit_signal("dropped")


func _pick_occupant() -> void:
	Globals.set_used_mana(level, 0)
	emit_signal("picked")
	_reset_scene_objects()
	_latest_area.set_droppable_on_cursor(true)
	_dragged_area = _latest_area
	_picked_occupant = _dragged_area.pick_occupant()
	_picked_occupant.set_picked(true)
	_picked_occupant.z_index += 1000
	
	for cell in get_tree().get_nodes_in_group("grid_cell"):
		var on_enemy_side = _dragged_area.position.x < 0 and cell.position.x > 0 or\
		_dragged_area.position.x > 0 and cell.position.x < 0
		cell.set_on_enemy_side(on_enemy_side)


func _area_entered(area: Area2D) -> void:
	if area is GridCell:
		area.set_hovering(true)
		area.set_droppable_on_cursor(_dragged_area != null)
		if area.occupant_can_be_moved():
			emit_signal("soldier_hovered")
		if _dragged_area:
			var mana_result = _mana - _get_mana_cost(area, _dragged_area)
			area.set_exceeds_mana(mana_result < 0)
			_notify_mana(mana_result)
		_latest_area = area


func _area_exited(area: Area2D) -> void:
	if area is GridCell:
		area.set_hovering(false)
		area.set_droppable_on_cursor(false)
		if _latest_area == area:
			_latest_area = null


func _reset_scene_objects() -> void:
	for grid_cell in get_tree().get_nodes_in_group("grid_cell"):
		grid_cell.modulate.a = 0
	for projectile in get_tree().get_nodes_in_group("projectiles"):
		projectile.queue_free()
	for soldier in get_tree().get_nodes_in_group("soldiers"):
		soldier.start_attack()


func _on_UndoButton_button_up() -> void:
	monitoring = true
	if not _dragged_area:
		_undo()
		_reset_scene_objects()


func _on_RestartButton_button_up() -> void:
	monitoring = true
	Globals.set_used_mana(level, 0)
	while _undo_stack.size() > 0:
		_undo()
		yield(get_tree().create_timer(0.1), "timeout")
	_reset_scene_objects()
	emit_signal("can_undo", false)


func _on_StartBattleButton_button_up() -> void:
	monitoring = false
	_soldier_got_hit = false
	var soldiers = get_tree().get_nodes_in_group("soldiers")
	for soldier in soldiers:
		if not soldier.is_connected("got_hit", self, "_on_Soldier_got_hit"):
			soldier.connect("got_hit", self, "_on_Soldier_got_hit", [], CONNECT_ONESHOT)
	for soldier in soldiers:
		soldier.execute_attack()
	Globals.set_used_mana(level, _used_mana)
	if _soldier_got_hit:
		emit_signal("failed")
	else:
		emit_signal("succeeded")


func _on_Soldier_got_hit() -> void:
	_soldier_got_hit = true


func _on_Grid_all_standing() -> void:
	monitoring = true
	for soldier in get_tree().get_nodes_in_group("soldiers"):
		soldier.start_attack()
