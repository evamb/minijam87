extends Area2D


onready var collision_shape = $CollisionShape2D


func _ready() -> void:
	pass # Replace with function body.


func set_size(size: int) -> void:
	collision_shape.shape.set_extents(Vector2(size / 2.0, size / 2.0))


func _on_GridCell_mouse_entered() -> void:
	modulate = Color.blue


func _on_GridCell_mouse_exited() -> void:
	modulate = Color.white
