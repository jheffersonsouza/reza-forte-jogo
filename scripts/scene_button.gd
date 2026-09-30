extends Button
## Button that swaps the whole screen for another scene.

@export_file("*.tscn") var target_scene: String
## Lets keyboard players press Enter right away on this screen.
@export var autofocus := false


func _ready() -> void:
	if autofocus:
		grab_focus.call_deferred()


func _pressed() -> void:
	get_tree().change_scene_to_file(target_scene)
