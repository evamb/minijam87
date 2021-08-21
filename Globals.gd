extends Node


func calc_hit_cells(start_cell_pos: Vector2, target_cells: Array, direction: int) -> Array:
	var cells = Array()
	for cell_pos in target_cells:
		var pos = Vector2(cell_pos.x * direction, cell_pos.y) + start_cell_pos
		for cell in get_tree().get_nodes_in_group("grid_cell"):
			if cell._cell_pos == pos:
				cells.append(cell)
	return cells
