tool
extends CellObject
class_name Soldier

export(Array, Vector2) var target_cells


func _ready() -> void:
	pass
	#if Engine.editor_hint:
#		set_process(false)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		execute_attack()


func get_hit_cells() -> Array:
	return Globals.calc_hit_cells(_cell_pos, target_cells, _direction)


func execute_attack() -> void:
	for cell in get_hit_cells():
		if not cell.hit(HitInfo.new(self, _direction)):
			return


func hit(hit_info: HitInfo) -> bool:
	print("%s says ouch" % name)
	if "Crossbow" in hit_info.get_source().name:
		return false
	return true


func weapon_hit_obstacle(_obstacle: Obstacle, _hit_info: HitInfo) -> bool:
	return true
