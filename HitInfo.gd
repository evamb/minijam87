extends Object
class_name HitInfo

var _source = null setget , get_source
var _bounces = 0 setget , get_bounces
var _direction = 1 setget set_direction, get_direction

func _init(source: Object, direction: int) -> void:
	_source = source
	_direction = direction
	

func get_source() -> Object:
	return _source
	

func get_bounces() -> int:
	return _bounces
	
	
func increment_bounces() -> void:
	_bounces += 1


func set_direction(dir: int) -> void:
	_direction = dir


func get_direction() -> int:
	return _direction
