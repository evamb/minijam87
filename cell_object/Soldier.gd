tool
extends CellObject
class_name Soldier

export(Array, Vector2) var target_cells


func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		execute_attack()


func get_hit_cells() -> Array:
	var cells = Array()
	for cell_pos in target_cells:
		var pos = Vector2(cell_pos.x * _direction, cell_pos.y) + _cell_pos
		for cell in get_tree().get_nodes_in_group("grid_cell"):
			if cell._cell_pos == pos:
				cells.append(cell)
	return cells


func execute_attack() -> void:
	for cell in get_hit_cells():
		if not cell.hit(self):
			return


func hit(source: CellObject) -> bool:
	print("%s says ouch" % name)
	if "Crossbow" in source.name:
		return false
	return true
