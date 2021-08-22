extends Sprite

export(float) var velocity

var _curve: Curve2D
var _baked_length: float
var _curve_pos = 0


func fire(target: Vector2) -> void:
	var curve = Curve2D.new()
	curve.add_point(global_position)
	var up = Vector2.UP * 200 + (global_position + target) / 2.0
	curve.add_point(up)
	curve.add_point(target)
	_curve = curve
	_baked_length = curve.get_baked_length()
	set_physics_process(true)


func _ready() -> void:
	set_physics_process(false)


func _physics_process(delta: float) -> void:
	var progress = _curve_pos / _baked_length
	var speed_factor = lerp(1, 0.15, progress * 2 if progress < 0.5 else (1 - progress) * 2)
	_curve_pos += delta * velocity * speed_factor
	
	if _curve_pos > _baked_length:
		set_physics_process(false)
		
	var next_pos = _curve.interpolate_baked(_curve_pos)
	
	global_position = next_pos
