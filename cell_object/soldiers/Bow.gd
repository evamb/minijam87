tool
extends Soldier

func weapon_hit_obstacle(obstacle: Obstacle, hit_info: HitInfo) -> bool:
	hit_info.increment_bounces()
	if "Tree" in obstacle.name:
		_drop_arrow(obstacle, hit_info)
	return false


func _drop_arrow(obstacle: Obstacle, hit_info: HitInfo) -> void:
	var dir = -hit_info.get_direction()
	var hit_cells = Globals.calc_hit_cells(obstacle.get_cell_pos() + Vector2.RIGHT * dir, [Vector2.ZERO], dir)
	var new_hit = Globals.clone_hit_info(hit_info)
	new_hit.set_direction(dir)
	# should only be 1 or 0 cells
	if hit_cells.size() == 1:
		hit_cells[0].hit(new_hit)
