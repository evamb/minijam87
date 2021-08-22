tool
extends Soldier

onready var Arrow = preload("res://cell_object/soldiers/projectiles/Arrow.tscn")

var _cur_hit_info = null

func execute_attack() -> HitInfo:
	_cur_hit_info = .execute_attack()
	return _cur_hit_info


func fire_arrow() -> void:
	var arrow = Arrow.instance()
	get_parent().add_child(arrow)
	arrow.global_position = global_position + Vector2.UP * 30
	var target;
	if _cur_hit_info:
		target = _cur_hit_info.get_target().global_position
	else:
		var hit_cells = get_hit_cells()
		if hit_cells.size() > 0:
			target = hit_cells[0].global_position
		else:
			target = global_position + Vector2(target_cells[0].x * _direction, target_cells[0].y) * get_parent().cell_size
	arrow.fire(target)


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
