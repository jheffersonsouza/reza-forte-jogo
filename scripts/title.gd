extends Control


func _ready() -> void:
	%QuitButton.pressed.connect(get_tree().quit)
