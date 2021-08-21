extends HBoxContainer


onready var _undo_button = $UndoButton

func _ready() -> void:
	_undo_button.disabled = true


func _on_Cursor_can_undo(enabled: bool) -> void:
	_undo_button.disabled = not enabled
