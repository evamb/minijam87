tool
extends Node2D

var level: Dictionary = {}

export(int) var width;
export(int) var height;
export(int) var cell_size;
export(bool) var build;
export(Dictionary) var level_coordinates = {
	Vector2(12, 4): "stone"
}

onready var GridCell = preload("res://grid/GridCell.tscn")


func _ready() -> void:
	if not Engine.editor_hint:
		_build_grid()


func _process(delta: float) -> void:
	if build:
		_build_grid()


func _build_grid() -> void:
	build = false
	for i in get_children():
		i.queue_free()
	var half_width = width / 2.0
	var half_height = height / 2.0
	var rest_width = width % 2
	var rest_height = height % 2
	var width_offset = floor(half_width)
	var height_offset = floor(half_height)
	for x in range(-width_offset, ceil(half_width)):
		for y in range(-height_offset, ceil(half_height)):
			var coords = Vector2(x, y)
			var cell = GridCell.instance()
			cell.set_cell_pos(coords)
			add_child(cell)
			cell.set_size(cell_size - 2)
			cell.position.x = x * cell_size + (1 - rest_width) * cell_size / 2.0
			cell.position.y = y * cell_size + (1 - rest_height) * cell_size / 2.0
			cell.set_owner(get_tree().get_edited_scene_root())
			var pos = Vector2(x + width_offset, y + height_offset)
			if level_coordinates.has(pos):
				cell.create_occupant(level_coordinates[pos])
				


