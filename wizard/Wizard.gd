extends Node2D

var field_magic: Array = []

onready var state_machine: AnimationNodeStateMachinePlayback = $AnimationTree.get("parameters/playback")
onready var FieldMagic = preload("res://wizard/FieldMagic.tscn")
onready var _audio = $AudioStreamPlayer

func start_magic() -> void:
	state_machine.travel('magic_loop')


func stop_magic() -> void:
	state_machine.travel('idle')


func magic_stop_time() -> void:
	_audio.play()
	state_machine.travel("magic_stop_time")
	var x_extends = 500
	var y_extends = 300
	var quadrants = [
		Vector2(-x_extends, -y_extends),
		Vector2(x_extends, -y_extends),
		Vector2(-x_extends, y_extends),
		Vector2(x_extends, y_extends),
	]
	var offset = $"../Grid".global_position
	for quadrant in quadrants:
		yield(get_tree().create_timer(rand_range(0.15, 0.3)), "timeout")
		var pos = offset + Vector2(
			quadrant.x * randf() * 0.9 + quadrant.x * 0.1,
			quadrant.y * randf() * 0.9 + quadrant.y * 0.1)
		var field_magic = FieldMagic.instance()
		get_parent().add_child(field_magic)
		field_magic.global_position = pos
		field_magic.flip_h = randi() % 2 == 0
		field_magic.flip_v = randi() % 2 == 0
		play_field_magic(field_magic)


func play_field_magic(field_magic: AnimatedSprite) -> void:
	field_magic.play()
	yield(field_magic, "animation_finished")
	field_magic.queue_free()
