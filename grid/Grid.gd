extends Node2D

export(int) var width;
export(int) var height;
export(int) var cell_size;

onready var GridCell = preload("res://grid/GridCell.tscn")

func _ready() -> void:
	var half_width = width / 2.0
	var half_height = height / 2.0
	var rest_width = width % 2
	var rest_height = height % 2
	for x in range(-floor(half_width), ceil(half_width)):
		for y in range(-floor(half_height), ceil(half_height)):
			var cell = GridCell.instance()
			add_child(cell)
			cell.set_size(cell_size)
			cell.position.x = x * cell_size + (1 - rest_width) * cell_size / 2.0
			cell.position.y = y * cell_size + (1 - rest_height) * cell_size / 2.0


