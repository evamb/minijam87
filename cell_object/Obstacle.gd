tool
extends CellObject
class_name Obstacle


func hit(hit_info: HitInfo) -> bool:
	hit_info.increment_bounces()
	if hit_info.get_bounces() > 3:
		return false
	return hit_info.get_source().weapon_hit_obstacle(self, hit_info)

