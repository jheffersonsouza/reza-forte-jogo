extends Control
## One night of prayer: the grandmother shows the sequence, the player repeats it.

const GOAL := 8
const VICTORY_SCENE := "res://scenes/victory.tscn"
const DEFEAT_SCENE := "res://scenes/defeat.tscn"
# Objects rest in the dark and flare up like they caught the candlelight.
const DIM := Color(0.5, 0.42, 0.36)
const LIT := Color(1.8, 1.5, 1.1)
const FLASH_SECONDS := 0.45
const GAP_SECONDS := 0.25
const PAUSE_SECONDS := 0.8
# Long enough to see the last pick light up, short enough to still feel immediate.
const ENDING_BEAT_SECONDS := 0.35

var _prayer: PrayerSequence

@onready var _round_label: Label = %RoundLabel
@onready var _turn_label: Label = %TurnLabel
@onready var _objects: Array[BaseButton] = [%Arruda, %SalGrosso, %Terco, %Vela]


func _ready() -> void:
	_prayer = PrayerSequence.new(_objects.size(), GOAL)
	for index in _objects.size():
		_objects[index].modulate = DIM
		_objects[index].pressed.connect(_on_object_pressed.bind(index))
	_start_round()


func _unhandled_input(event: InputEvent) -> void:
	for index in _objects.size():
		if event.is_action_pressed("pick_object_%d" % (index + 1)) and not _objects[index].disabled:
			get_viewport().set_input_as_handled()
			_on_object_pressed(index)


func _start_round() -> void:
	_set_input_enabled(false)
	_prayer.extend()
	_round_label.text = "Rodada %d de %d" % [_prayer.steps.size(), GOAL]
	_turn_label.text = "Presta atenção na reza da vó..."
	await _wait(PAUSE_SECONDS)
	for index in _prayer.steps:
		await _flash(_objects[index]).finished
		await _wait(GAP_SECONDS)
	_turn_label.text = "Tua vez! Repete a reza."
	_set_input_enabled(true)


func _on_object_pressed(index: int) -> void:
	_flash(_objects[index])
	match _prayer.submit(index):
		PrayerSequence.Result.WRONG:
			_end(DEFEAT_SCENE)
		PrayerSequence.Result.WON:
			_end(VICTORY_SCENE)
		PrayerSequence.Result.ROUND_COMPLETE:
			_set_input_enabled(false)
			_turn_label.text = "Arretado! A reza tá segurando."
			await _wait(PAUSE_SECONDS)
			_start_round()


func _end(scene: String) -> void:
	_set_input_enabled(false)
	await _wait(ENDING_BEAT_SECONDS)
	get_tree().change_scene_to_file(scene)


func _set_input_enabled(enabled: bool) -> void:
	for button in _objects:
		button.disabled = not enabled
		button.mouse_default_cursor_shape = CURSOR_POINTING_HAND if enabled else CURSOR_ARROW


func _flash(button: BaseButton) -> Tween:
	var tween := create_tween()
	tween.tween_property(button, "modulate", DIM, FLASH_SECONDS).from(LIT)
	return tween


func _wait(seconds: float) -> Signal:
	return get_tree().create_timer(seconds).timeout
