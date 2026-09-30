class_name PrayerSequence
extends RefCounted
## Simon rules with no nodes attached: the sequence only grows, one wrong pick ends it.

enum Result { CORRECT, ROUND_COMPLETE, WON, WRONG }

var steps: Array[int] = []
var _object_count: int
var _goal: int
var _next_step := 0


func _init(object_count: int, goal: int) -> void:
	_object_count = object_count
	_goal = goal


func extend() -> void:
	steps.append(randi_range(0, _object_count - 1))
	_next_step = 0


func submit(index: int) -> Result:
	if index != steps[_next_step]:
		return Result.WRONG
	_next_step += 1
	if _next_step < steps.size():
		return Result.CORRECT
	return Result.WON if steps.size() == _goal else Result.ROUND_COMPLETE
