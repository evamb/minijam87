extends MarginContainer

onready var _undo_button = $HBoxContainer/UndoButton
onready var _restart_button = $HBoxContainer/RestartButton
onready var _mana_label = $HBoxContainer/Mana


func _ready() -> void:
	_undo_button.disabled = true
	_restart_button.disabled = true


func _on_Cursor_can_undo(enabled: bool) -> void:
	_undo_button.disabled = not enabled
	_restart_button.disabled = not enabled


func _on_Cursor_mana_changed(mana: int) -> void:
	_mana_label.text = str(mana)
