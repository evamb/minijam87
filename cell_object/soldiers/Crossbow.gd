tool
extends Soldier

func weapon_hit_obstacle(obstacle: Obstacle, hit_info: HitInfo) -> bool:
	if "Rock" in obstacle.name:
		_reflect_crossbow(obstacle, hit_info)
	return false


func _reflect_crossbow(obstacle: Obstacle, hit_info: HitInfo) -> void:
	var dir = -hit_info.get_direction()
	hit_info.set_direction(dir)
	var start_cell = obstacle.get_cell_pos() + Vector2.RIGHT * dir
	var target_cells = Array()
	for i in 12:
		target_cells.append(Vector2(1 + i, 0))
	for cell in Globals.calc_hit_cells(start_cell, target_cells, dir):
		if not cell.hit(hit_info):
			return

