extends AudioStreamPlayer
## The song loops on every screen and stops on the endings, which play their own
## sound. Volume is pinned at +24 dB, the inspector's maximum.

const ENDINGS := ["res://scenes/victory.tscn", "res://scenes/defeat.tscn"]


func _ready() -> void:
	get_tree().scene_changed.connect(_on_scene_changed)


func _on_scene_changed() -> void:
	if get_tree().current_scene.scene_file_path in ENDINGS:
		stop()
	elif not playing:
		play()
