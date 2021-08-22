tool
extends Soldier

func weapon_hit_obstacle(obstacle: Obstacle, hit_info: HitInfo) -> bool:
	if "Rock" in obstacle.name:
		hit_info.get_source().hit(Globals.clone_hit_info(hit_info))
		_play_fail()
		return false
	if "Tree" in obstacle.name:
		_chop_tree(obstacle, hit_info)
		return false
	return true
	

func _play_fail() -> void:
	if _anim_wait_timer:
		yield(_anim_wait_timer, "timeout")
	_state_machine.travel("attack_fail")


func _chop_tree(obstacle: Obstacle, hit_info: HitInfo) -> void:
	var cells = Globals.calc_hit_cells(obstacle.get_cell_pos(), [
		Vector2.RIGHT
	], _direction)
	for cell in cells:
		var new_hit = HitInfo.new(obstacle, _direction, cell, hit_info.get_bounces())
		cell.hit(new_hit)
	yield(get_tree().create_timer(0.25), "timeout")
	if _direction < 0:
		obstacle.fall_left()
	else:
		obstacle.fall_right()
