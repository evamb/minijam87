tool
extends Soldier

func weapon_hit_obstacle(_obstacle: Obstacle, _hit_info: HitInfo) -> bool:
	if "Rock" in _obstacle.name:
		_hit_info.get_source().hit(_hit_info)
		return false
	return true
