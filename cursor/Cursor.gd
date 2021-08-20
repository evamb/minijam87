extends Area2D


func _ready() -> void:
	connect("area_entered", self, "_area_entered")
	connect("area_exited", self, "_area_exited")
	pass


func _process(delta: float) -> void:
	position = get_viewport().get_mouse_position()


func _area_entered(area: Area2D) -> void:
	if area is GridCell:
		area.set_highlighted(true)


func _area_exited(area: Area2D) -> void:
	if area is GridCell:
		area.set_highlighted(false)
