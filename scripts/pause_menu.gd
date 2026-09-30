extends Control
## Esc freezes the night. This menu keeps processing while the tree is paused.

const TITLE_SCENE := "res://scenes/title.tscn"


func _ready() -> void:
	hide()
	%ResumeButton.pressed.connect(_resume)
	%TitleButton.pressed.connect(_go_to_title)
	%QuitButton.pressed.connect(get_tree().quit)


func _unhandled_input(event: InputEvent) -> void:
	if not event.is_action_pressed("ui_cancel"):
		return
	get_viewport().set_input_as_handled()
	if visible:
		_resume()
	else:
		get_tree().paused = true
		show()
		%ResumeButton.grab_focus()


func _resume() -> void:
	hide()
	get_tree().paused = false


func _go_to_title() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file(TITLE_SCENE)
