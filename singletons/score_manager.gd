extends Node

const DEFAULT_SCORE: int = 1000

var _level_selected: int = 1
var _level_scores: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_level_selected(val: int) -> void:
	_level_selected = val
	
func get_level_selected() -> int:
	return _level_selected

func check_and_add(level: String) -> void:
	if (_level_scores.has(level) == false):
		_level_scores[level] = DEFAULT_SCORE

func set_level_score(score: int, level: String) -> void:
	check_and_add(level)
	if (_level_scores[level] > score):
		_level_scores[level] = score
		
func get_best_level_score(level: String) -> int:
	check_and_add(level)
	return _level_scores[level]
