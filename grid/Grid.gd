tool
extends Node2D

signal all_standing

var _level: Dictionary = {}
var _waiting_fns = 0

export(int) var width;
export(int) var height;
export(int) var cell_size;
export(bool) var build;
export(bool) var random;
export(Dictionary) var level_coordinates = {
	Vector2(12, 4): "stone"
} setget set_level_coords

onready var GridCell = preload("res://grid/GridCell.tscn")


func get_cell(coords: Vector2) -> GridCell:
	if _level.has(coords):
		return _level[coords]
	return null


func set_level_coords(coords: Dictionary) -> void:
	level_coordinates = coords


func _ready() -> void:
	if not Engine.editor_hint:
		_build_grid()


func _process(_delta: float) -> void:
	if build:
		_build_grid()


func _generate_random_level() -> Dictionary:
	var coords = {}
	var num_placements = 5 + randi() % 15
	var objects = ["rock", "tree", "crossbow", "bow", "sword"]
	for obj in objects:
		#generate at least one on each side
		coords[_generate_unused_random_cell(coords, width / 2, 0)] = obj
		coords[_generate_unused_random_cell(coords, width, width / 2)] = obj
	while num_placements > 0:
		var obj = objects[randi() % objects.size()]
		coords[_generate_unused_random_cell(coords)] = obj
		num_placements -= 1		
	return coords


func _generate_unused_random_cell(coords: Dictionary,
		width_limit = width,
		width_offset = 0) -> Vector2:
	var pos = Vector2(width_offset + randi() % (width_limit - width_offset),
		randi() % height)
	while coords.has(pos):
		pos = Vector2(width_offset + randi() % (width_limit - width_offset),
		randi() % height)
	return pos


func _build_grid() -> void:
	build = false
	var coords = level_coordinates
	if random and Engine.editor_hint:
		coords = _generate_random_level()
		set_level_coords(coords)
	for i in get_children():
		i.queue_free()
	print("generated level: %s" % JSON.print(coords))
	var half_width = width / 2.0
	var half_height = height / 2.0
	var rest_width = width % 2
	var rest_height = height % 2
	var width_offset = floor(half_width)
	var height_offset = floor(half_height)
	_waiting_fns = 0
	var awaited_fns = Array();
	for y in range(-height_offset, ceil(half_height)):
		for x in range(-width_offset, ceil(half_width)):
			var cell_coords = Vector2(x, y)
			var cell = GridCell.instance()
			cell.set_cell_pos(cell_coords)
			_level[cell_coords] = cell
			add_child(cell)
			cell.set_size(cell_size - 2)
			cell.position.x = x * cell_size + (1 - rest_width) * cell_size / 2.0
			cell.position.y = y * cell_size + (1 - rest_height) * cell_size / 2.0
			cell.set_owner(get_tree().get_edited_scene_root())
			var pos = Vector2(x + width_offset, y + height_offset)
			if coords.has(pos):
				_waiting_fns += 1
				awaited_fns.push_back(cell.create_occupant(coords[pos]))
	for fn in awaited_fns:
		_await_fn(fn)


func _await_fn(fn_state: GDScriptFunctionState) -> void:
	if fn_state.is_valid():
		yield(fn_state, "completed")
	_waiting_fns -= 1
	if _waiting_fns == 0 and not Engine.editor_hint:
		emit_signal("all_standing")
