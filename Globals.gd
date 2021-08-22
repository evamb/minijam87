extends Node

var _used_mana = {}
var _skip_tutorial = false

func _ready() -> void:
	randomize()


func set_skip_tutorial(skip: bool) -> void:
	_skip_tutorial = skip


func get_skip_tutorial() -> bool:
	return _skip_tutorial


func set_used_mana(level: int, mana: int) -> void:
	_used_mana[level] = mana


func get_used_mana() -> int:
	var sum = 0
	for mana in _used_mana.values():
		sum += mana
	return sum


func reset_used_mana() -> void:
	_used_mana = {}


func calc_hit_cells(start_cell_pos: Vector2, target_cells: Array, direction: int) -> Array:
	var cells = Array()
	for cell_pos in target_cells:
		var pos = Vector2(cell_pos.x * direction, cell_pos.y) + start_cell_pos
		for cell in get_tree().get_nodes_in_group("grid_cell"):
			if cell._cell_pos == pos:
				cells.append(cell)
	return cells


func clone_hit_info(hit_info: HitInfo) -> HitInfo:
	var new_hit_info = HitInfo.new(hit_info.get_source(), hit_info.get_direction(), hit_info.get_target())
	for i in hit_info._bounces:
		new_hit_info.increment_bounces()
	return new_hit_info
