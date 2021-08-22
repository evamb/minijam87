extends Node2D

onready var _tween = $Tween
onready var _label = $CanvasLayer/VBoxContainer/Label
onready var _button = $CanvasLayer/VBoxContainer/Button

func _ready() -> void:
	yield(get_tree().create_timer(0.5), "timeout")
	_tween.interpolate_property(_label, "modulate", Color.transparent, Color.white, 1)
	_tween.start()
	yield(get_tree().create_timer(0.5), "timeout")
	_tween.interpolate_property(_button, "modulate", Color.transparent, Color.white, 1)
	_tween.start()


func _on_Button_button_up() -> void:
	_tween.interpolate_property(_button, "modulate", Color.white, Color.transparent, 1)
	_tween.interpolate_property(_label, "modulate", Color.white, Color.transparent, 1)
	_tween.start()
	yield(_tween, "tween_all_completed")
	get_tree().change_scene("res://Tutorial.tscn")
