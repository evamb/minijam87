tool
extends Soldier

func weapon_hit_obstacle(obstacle: Obstacle, hit_info: HitInfo) -> bool:
	if "Rock" in obstacle.name:
		hit_info.get_source().hit(Globals.clone_hit_info(hit_info))
		return false
	return true
