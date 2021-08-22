tool
extends Obstacle

var has_fallen = false

onready var _animation_player: AnimationPlayer = $AnimationPlayer
onready var _sprite = $Sprite


func hit(hit_info: HitInfo) -> bool:
	if has_fallen:
		return false
	has_fallen = has_fallen or "Sword" in hit_info.get_source().name
	return .hit(hit_info)


func fall_right() -> void:
	_animation_player.play("fall_right")


func fall_left() -> void:
	_animation_player.play("fall_left")


func arrow_fall_left() -> void:
	_animation_player.play("arrow_fall_left")


func arrow_fall_right() -> void:
	_animation_player.play("arrow_fall_right")


func reset() -> void:
	.reset()
	if has_fallen:
		_animation_player.play_backwards()
		has_fallen = false
	else:
		_sprite.frame = 0
