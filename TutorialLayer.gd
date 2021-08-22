extends CanvasLayer

signal soldiers_arrived
signal soldier_hovered

const dialog = [
	"The glade, beautiful as always. But what's this? Someone's coming! (click to proceed)",
	"FREEZE!",
	"You won't defile this place with your blood!",
	"I won't let them kill each other. Maybe I can prevent this battle...",
	"Move your mouse on top of a soldier to see where they will attack!",
	"%s %s %s %s" % [
		"Hold your left mouse button to move soldiers.",
		"Make sure they don't kill anybody. The red areas tell you where",
		"they'll deal damage. But beware: hitting the surroundings might",
		"change the outcome of an attack."
	],
	"Moving soldiers consumes mana, so move them as little as possible!"
]

onready var _textbox = $TextBox


func _ready() -> void:
	if not Globals.get_skip_tutorial():
		_play_dialog()
	Globals.set_skip_tutorial(true)


func _play_dialog() -> void:
	yield(get_tree().create_timer(1), "timeout")
	get_tree().paused = true
	yield(_textbox.play_text(dialog[0]), "completed")
	get_tree().paused = false
	yield(self, "soldiers_arrived")
	get_tree().paused = true
	yield(_textbox.play_text(dialog[1]), "completed") # freeze
	get_tree().paused = false
	yield(get_tree().create_timer(2), "timeout")
	yield(_textbox.play_text(dialog[2]), "completed")
	yield(_textbox.play_text(dialog[3]), "completed")
	yield(_textbox.play_text(dialog[4]), "completed")
	get_tree().paused = false
	yield(self, "soldier_hovered")
	yield(get_tree().create_timer(1), "timeout")
	get_tree().paused = true;
	yield(_textbox.play_text(dialog[5]), "completed")
	yield(_textbox.play_text(dialog[6]), "completed")
	get_tree().paused = false;


func _on_Grid_all_standing() -> void:
	emit_signal("soldiers_arrived")


func _on_Cursor_soldier_hovered() -> void:
	emit_signal("soldier_hovered")
