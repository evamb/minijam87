tool
extends Node2D

export(int) var width;
export(int) var height;
export(int) var cell_size;
export(bool) var build;
export(Dictionary) var level_coordinates = {
	"stones": PoolVector2Array(),
	"trees": PoolVector2Array(),
	"swords": PoolVector2Array(),
	"crossbows": PoolVector2Array(),
	"bows": PoolVector2Array(),
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
		for x in range(-floor(half_width), ceil(half_width)):
			for y in range(-floor(half_height), ceil(half_height)):
				var cell = GridCell.instance()
				add_child(cell)
				cell.set_size(cell_size - 2)
				cell.position.x = x * cell_size + (1 - rest_width) * cell_size / 2.0
				cell.position.y = y * cell_size + (1 - rest_height) * cell_size / 2.0
				cell.occupation_state = randi() % 2
				cell.set_owner(get_tree().get_edited_scene_root())


