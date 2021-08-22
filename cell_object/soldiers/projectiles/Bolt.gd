extends Sprite

signal reached_target

export(float) var velocity

var _distance
var _direction

onready var _audio = $AudioStreamPlayer2D

func fire(distance: float, direction: Vector2) -> void:
	_distance = distance
	_direction = direction
	set_physics_process(true)


func play_stream(stream: AudioStream) -> void:
	_audio.stream = stream
	_audio.play()


func _ready() -> void:
	set_physics_process(false)


func _physics_process(delta: float) -> void:
	var travel = _direction * velocity * delta
	position += travel
	_distance -= travel.length()
	if _distance <= 0:
		set_physics_process(false)
		emit_signal("reached_target", global_position)
		queue_free()
