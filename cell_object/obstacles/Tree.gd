tool
extends Obstacle


onready var _animation_player: AnimationPlayer = $AnimationPlayer


func fall_right() -> void:
	_animation_player.play("fall_right")


func fall_left() -> void:
	_animation_player.play("fall_left")
