extends "res://ui/MainMenu.gd"

onready var _score = $CanvasLayer/VBoxContainer/Score


func _ready() -> void:
	_tween.interpolate_property(_score, "modulate", Color.transparent, Color.white, 1)
	_tween.start()
	_score.text = "%s%s" % [_score.text, Globals.get_used_mana()]


func _on_Button_button_up() -> void:
	._on_Button_button_up()
	_tween.interpolate_property(_score, "modulate", Color.white, Color.transparent, 1)
	_tween.start()
	Globals.reset_used_mana()
