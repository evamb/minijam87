tool
extends CellObject
class_name Soldier

signal got_hit

export(Array, Vector2) var target_cells

var _prev_pos: Vector2
var _anim_wait_timer: SceneTreeTimer = null

onready var _magic_sprite = $AnimatedSprite
onready var _state_machine: AnimationNodeStateMachinePlayback = $AnimationTree.get("parameters/playback")
onready var _sprite = $Sprite
onready var _audio = $AudioStreamPlayer2D
onready var _stream_arrow_hits = preload("res://cell_object/soldiers/Bow_arrow_hits_soldier.mp3")
onready var _stream_death = preload("res://cell_object/soldiers/Death_fall_to_ground.mp3")


func spawn() -> void:
	_prev_pos = global_position
	_tween.interpolate_property(self, "position",
			position + Vector2.LEFT * 1000 * _direction, position, rand_range(4.0, 5.0), Tween.TRANS_CUBIC)
	_tween.start()
	yield(_tween, "tween_all_completed")
	_state_machine.travel("idle")


func start_attack() -> void:
	_state_machine.travel("attack_start")


func _play_anim(anim: String, wait_time: float, stream: AudioStream = null) -> void:
	_anim_wait_timer = get_tree().create_timer(wait_time)
	yield(_anim_wait_timer, "timeout")
	_anim_wait_timer = null
	if stream:
		_audio.stream = stream
		_audio.play()
	_state_machine.travel(anim)


func set_direction(dir: int) -> void:
	.set_direction(dir)
	_sprite.flip_h = dir < 0


func get_hit_cells() -> Array:
	return Globals.calc_hit_cells(_cell_pos, target_cells, _direction)


func execute_attack() -> HitInfo:
	_play_anim("attack", rand_range(0.1, 0.5))
	for cell in get_hit_cells():
		var hit_info = HitInfo.new(self, _direction, cell)
		if not cell.hit(hit_info):
			return hit_info
	return null


func hit(hit_info: HitInfo) -> bool:
	emit_signal("got_hit")
	var source = hit_info.get_source()
	var source_name = source.name
	var death_delay = 0.5
	var stream = null
	if "Bow" in source_name:
		death_delay = 1.5 if hit_info.get_bounces() == 0 else 2.4
		stream = _stream_arrow_hits
	if source != self or "Crossbow" in source_name:
		_play_anim("death", death_delay, stream)
	if "Crossbow" in source_name:
		return false
	return true


func weapon_hit_obstacle(_obstacle: Obstacle, _hit_info: HitInfo) -> bool:
	return true


func set_picked(picked: bool) -> void:
	_magic_sprite.visible = picked
