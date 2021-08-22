extends MarginContainer

export(String, FILE) var next_scene

onready var _undo_button = $VBoxContainer/HBoxContainer/UndoButton
onready var _restart_button = $VBoxContainer/HBoxContainer/RestartButton
onready var _start_battle_button = $VBoxContainer/HBoxContainer/StartBattleButton
onready var _proceed_button = $VBoxContainer/MarginContainer/VBoxContainer/ProceedButton
onready var _mana_label = $VBoxContainer/HBoxContainer2/VBoxContainer/Mana
onready var _total_mana_label = $VBoxContainer/HBoxContainer2/VBoxContainer/TotalManaUsed
onready var _fail_label = $VBoxContainer/MarginContainer/LabelFail
onready var _success_label = $VBoxContainer/MarginContainer/VBoxContainer/LabelSuccess
onready var _tween = $Tween
onready var _success_message = _success_label.text

func _ready() -> void:
	_undo_button.disabled = true
	_restart_button.disabled = true
	_proceed_button.disabled = true
	_proceed_button.modulate.a = 0
	_success_label.modulate.a = 0
	_total_mana_label.text = str(Globals.get_used_mana())
	_fail_label.modulate.a = 0
	modulate = Color.transparent
	yield(get_tree().create_timer(3), "timeout")
	_tween.interpolate_property(self, "modulate", Color.transparent, Color.white, 2, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	_tween.start()


func _fade_label(label: Label, show: bool) -> void:
	_tween.interpolate_property(label, "modulate", null, Color.white if show else Color.transparent, 0.5)
	_tween.start()


func _on_Cursor_can_undo(enabled: bool) -> void:
	_undo_button.disabled = not enabled
	_restart_button.disabled = not enabled


func _on_Cursor_mana_changed(mana: int) -> void:
	_mana_label.text = str(mana)


func _on_StartBattleButton_button_up() -> void:
	_start_battle_button.disabled = true
	_restart_button.disabled = true
	var undo_disabled = _undo_button.disabled
	_undo_button.disabled = true
	yield(get_tree().create_timer(3), "timeout")
	_restart_button.disabled = false
	_undo_button.disabled = undo_disabled


func _on_RestartButton_button_up() -> void:
	_start_battle_button.disabled = false
	_restart_button.disabled = true
	_fade_success(false)
	_fade_label(_fail_label, false)


func _on_UndoButton_button_up() -> void:
	_start_battle_button.disabled = false
	_fade_success(false)
	_fade_label(_fail_label, false)


func _on_Cursor_mana_used_changed(mana: int) -> void:
	_total_mana_label.text = str(Globals.get_used_mana() + mana)


func _fade_success(show: bool) -> void:
	_fade_label(_success_label, show)
	_proceed_button.disabled = not show
	_tween.interpolate_property(_proceed_button, "modulate", null, Color.white if show else Color.transparent, 0.5)
	_tween.start()


func _on_Cursor_failed() -> void:
	yield(get_tree().create_timer(2), "timeout")
	_fade_label(_fail_label, true)


func _on_Cursor_picked() -> void:
	_start_battle_button.disabled = false
	_fade_label(_fail_label, false)
	_fade_success(false)


func _on_Cursor_succeeded() -> void:
	_success_label.text = _success_message.replace("{mana}", str(Globals.get_used_mana()))
	_fade_success(true)


func _on_ProceedButton_button_up() -> void:
	_proceed_button.disabled = true
	_tween.interpolate_property(self, "modulate", null, Color.transparent, 0.5)
	_tween.start()
	yield(_tween, "tween_all_completed")
	get_tree().change_scene(next_scene)
