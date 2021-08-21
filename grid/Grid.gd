tool
extends Node2D

enum OccupantTypes {
	STONES = 0, TREES = 1, SWORDS = 2, CROSSBOWS = 3, BOWS = 4
}

export(int) var width;
export(int) var height;
export(int) var cell_size;
export(bool) var build;
export(Dictionary) var level_coordinates = {
	Vector2(12, 4): 1
}

onready var GridCell = preload("res://grid/GridCell.tscn")

func _process(delta: float) -> void:
	if build:
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
				var cell = GridCell.instance()
				add_child(cell)
				cell.set_size(cell_size - 2)
				cell.position.x = x * cell_size + (1 - rest_width) * cell_size / 2.0
				cell.position.y = y * cell_size + (1 - rest_height) * cell_size / 2.0
				var pos = Vector2(x + width_offset, y + height_offset)
				if level_coordinates.has(pos):
					cell.set_occupant(level_coordinates[pos])
				else:
					cell.set_occupant(0)
				cell.set_owner(get_tree().get_edited_scene_root())


