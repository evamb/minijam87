tool
extends Soldier

export(Vector2) var bolt_offset = Vector2.ZERO

onready var Bolt = preload("res://cell_object/soldiers/projectiles/Bolt.tscn")
onready var _stream_stuck_in_tree = preload("res://cell_object/soldiers/projectiles/Bolt_stuck_in_tree.mp3")

var _reflect_hits = Array()


func execute_attack():
	var hit_info = .execute_attack()
	_spawn_bolt(global_position + bolt_offset, true, _direction, hit_info)


func weapon_hit_obstacle(obstacle: Obstacle, hit_info: HitInfo) -> bool:
	if "Rock" in obstacle.name:
		_reflect_crossbow(obstacle, hit_info)
	return false


func _spawn_bolt(global_pos: Vector2, do_fire = false, direction: int = 0, hit_info: HitInfo = null) -> Node:
	var bolt = Bolt.instance()
	get_parent().add_child(bolt)
	bolt.global_position = global_pos
	bolt.flip_h = direction < 0
	var distance = 2000
	if hit_info:
		var target = hit_info.get_target()
		distance = global_pos.distance_to(target.global_position)
	if do_fire:
		bolt.fire(distance, direction * Vector2.RIGHT)
		bolt.connect("reached_target", self, "_on_bolt_reached_target", [hit_info], CONNECT_ONESHOT)
	return bolt


func _on_bolt_reached_target(pos: Vector2, hit_info: HitInfo) -> void:
	var hit = _reflect_hits.pop_back()
	if hit:
		_spawn_bolt(pos, true, hit.get_direction(), hit)
	if not hit_info:
		return
	var target = hit_info.get_target()
	if not target:
		return
	if "Tree" in target.get_occupant_name():
		var bolt = _spawn_bolt(target.global_position + bolt_offset + Vector2.LEFT * hit_info.get_direction() * 20, false, hit_info.get_direction())
		bolt.play_stream(_stream_stuck_in_tree)
		


func _reflect_crossbow(obstacle: Obstacle, hit_info: HitInfo) -> void:
	var dir = -hit_info.get_direction()
	var start_cell = obstacle.get_cell_pos() + Vector2.RIGHT * dir
	var target_cells = Array()
	for i in 12:
		target_cells.append(Vector2(1 + i, 0))
	for cell in Globals.calc_hit_cells(start_cell, target_cells, dir):
		var cur_hit = HitInfo.new(hit_info.get_source(), dir, cell, hit_info.get_bounces())
		if not cell.hit(cur_hit):
			_reflect_hits.append(cur_hit)
			return

