extends Node

signal package_changed

var score : int = 0
var current_package : Node2D = null
var high_score : int = 0

# High score ConfigFile
const SAVE_PATH : String = "user://save.cfg"
const SAVE_SECTION_SCORES : String = "scores"
const SAVE_KEY_HIGH_SCORE : String = "high_score"

'''
config file looks like this:
[scores]

high_score=2600

'''


func _ready() -> void:
	load_high_score()


func set_current_package(package: Node2D):
	current_package = package
	package_changed.emit()


func load_high_score() -> void:
	var config := ConfigFile.new()
	var result := config.load(SAVE_PATH)
	if result == OK:
		high_score = int(config.get_value(SAVE_SECTION_SCORES, SAVE_KEY_HIGH_SCORE, 0))
	else:
		# Missing or invalid file; initialize and save defaults
		high_score = 0
		save_high_score()


# save high score to config file
func save_high_score() -> void:
	var config := ConfigFile.new()
	config.set_value(SAVE_SECTION_SCORES, SAVE_KEY_HIGH_SCORE, high_score)
	config.save(SAVE_PATH)


# try to update high score if current score is greater than high score
func update_high_score(current_score: int) -> bool:
	if current_score > high_score:
		high_score = current_score
		save_high_score()
		return true
	return false


func get_high_score() -> int:
	return high_score


func reset_high_score() -> void:
	high_score = 0
	save_high_score()