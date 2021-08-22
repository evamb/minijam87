extends PanelContainer

signal skipped

onready var _tween = $Tween
onready var _label = $RichTextLabel

func _ready() -> void:
	# this is how it works
	yield(play_text("hello world! lorem ipsum dolor sit amet"), "completed")
	yield(play_text("second text blabla foobar!"), "completed")
	play_text("the final textdown!")
	pass


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_select") or Input.is_action_just_pressed("mouse_left"):
		_tween.stop_all()
		_label.percent_visible = 1
		emit_signal("skipped")


func play_text(new_text: String) -> void:
	_label.text = new_text
	_tween.interpolate_property(_label, "percent_visible", 0.0, 1.0, new_text.length() * 0.05)
	_tween.start()
	var tween_wait_state = wait_for_tween()
	var skip_wait_state = wait_for_skip()
	while tween_wait_state.is_valid() and skip_wait_state.is_valid():
		yield(get_tree(), "idle_frame")
	yield(self, "skipped")


func wait_for_skip() -> void:
	yield(self, "skipped")


func wait_for_tween() -> void:
	yield(_tween, "tween_completed")
