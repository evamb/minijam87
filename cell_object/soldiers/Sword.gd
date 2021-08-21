tool
extends Soldier

func weapon_hit_obstacle(obstacle: Obstacle, hit_info: HitInfo) -> bool:
	if "Rock" in obstacle.name:
		hit_info.get_source().hit(Globals.clone_hit_info(hit_info))
		return false
	if "Tree" in obstacle.name:
		_chop_tree(obstacle, hit_info)
		return false
	return true


func _chop_tree(obstacle: Obstacle, hit_info: HitInfo) -> void:
	var cells = Globals.calc_hit_cells(obstacle.get_cell_pos(), [
		Vector2.UP,
		Vector2.UP * 2
	], 0)
	var new_hit = Globals.clone_hit_info(hit_info)
	for cell in cells:
		cell.hit(new_hit)
