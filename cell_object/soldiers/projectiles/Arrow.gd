extends Sprite

export(float) var velocity

var _curve: Curve2D
var _baked_length: float
var _curve_pos = 0


func fire(target: Vector2) -> void:
	var curve = Curve2D.new()
	curve.add_point(global_position)
	var center = (global_position + target) / 2
	var up_left = Vector2((global_position.x + center.x) / 2, center.y - 200)
	var up_right = Vector2((target.x + center.x) / 2, center.y - 200)
	curve.add_point(up_left)
	curve.add_point(up_right)
		
	curve.add_point(target)
	_curve = curve
	_baked_length = curve.get_baked_length()
	set_physics_process(true)
	var next_pos = _curve.interpolate_baked(1)
	var target_rot = (next_pos - global_position).angle()
	
	rotation = target_rot


func get_curve_progress() -> float:
	return _curve_pos / _baked_length


func _ready() -> void:
	set_physics_process(false)


func _physics_process(delta: float) -> void:
	var progress = _curve_pos / _baked_length
	var speed_factor = lerp(1, 0.15, progress * 2 if progress < 0.5 else (1 - progress) * 2)
	_curve_pos += delta * velocity * speed_factor
	
	if _curve_pos > _baked_length:
		set_physics_process(false)
		
	var further_pos = _curve.interpolate_baked(min(_curve_pos + 120, _baked_length), true)
	var target_rot = (further_pos - global_position).angle()
	if abs(target_rot - rotation) > PI:
		target_rot += -TAU if target_rot > rotation else TAU
	rotation = lerp(rotation, target_rot, delta * 4)
	var next_pos = _curve.interpolate_baked(_curve_pos, true)
	global_position = next_pos
