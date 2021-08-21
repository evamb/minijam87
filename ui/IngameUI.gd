extends MarginContainer

onready var _undo_button = $VBoxContainer/HBoxContainer/UndoButton
onready var _restart_button = $VBoxContainer/HBoxContainer/RestartButton
onready var _start_battle_button = $VBoxContainer/HBoxContainer/StartBattleButton
onready var _mana_label = $VBoxContainer/HBoxContainer2/VBoxContainer/Mana
onready var _total_mana_label = $VBoxContainer/HBoxContainer2/VBoxContainer/TotalManaUsed


func _ready() -> void:
	_undo_button.disabled = true
	_restart_button.disabled = true
	_total_mana_label.text = str(Globals.get_used_mana())


func _on_Cursor_can_undo(enabled: bool) -> void:
	_undo_button.disabled = not enabled
	_restart_button.disabled = not enabled


func _on_Cursor_mana_changed(mana: int) -> void:
	_mana_label.text = str(mana)


func _on_StartBattleButton_button_up() -> void:
	_start_battle_button.disabled = true
	_restart_button.disabled = false


func _on_RestartButton_button_up() -> void:
	_start_battle_button.disabled = false
	_restart_button.disabled = true


func _on_UndoButton_button_up() -> void:
	_start_battle_button.disabled = false


func _on_Cursor_mana_used_changed(mana: int) -> void:
	_total_mana_label.text = str(Globals.get_used_mana() + mana)
