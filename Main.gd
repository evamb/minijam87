extends Node2D

onready var _tween = $Tween
onready var _bg_overlay = $BackgroundOverlay

func _ready() -> void:
	_tween.interpolate_property(_bg_overlay, "modulate", Color.white, Color.transparent, 1)
	_tween.start()
