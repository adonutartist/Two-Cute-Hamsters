extends Node

const LEVELS = ["Level1", "Level2", "CheeseRoom"]

var persist_camera:Camera = null
var current_hammy: Player
var current_tammy

var got_cheese := false

func save():
	var save_dict = {}
	return save_dict

func save_game():
	var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	var json_string = JSON.stringify(save())
	save_file.store_line(json_string)

func load_game():
	if not FileAccess.file_exists("user://savegame.save"):
		return # Error! We don't have a save to load.
	var save_file = FileAccess.open("user://savegame.save", FileAccess.READ)
	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line()
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue

func change_scenes(scene_id: String):
	UiCanvasLayer.erase_tammy_ui()
	get_tree().change_scene_to_file("res://Maps/%s.tscn" % scene_id)
	UiCanvasLayer.erase_vignette_ui()
	if current_tammy != null:
		current_tammy._set_time(105)

func reset_data():
	got_cheese = false

func goto_next_level():
	UiCanvasLayer.add_tammy_ui()
	var current_level = _get_current_scene().name
	var level_idx = LEVELS.find(current_level)
	if got_cheese:
		change_scenes(LEVELS[level_idx - 1])
	else:
		change_scenes(LEVELS[level_idx + 1])
	UiCanvasLayer.add_vignette_ui()

func _get_current_scene() -> Node:
	var root = get_tree().get_root()
	return root.get_child(root.get_child_count() - 1)

func get_current_level() -> Level:
	return _get_current_scene() as Level
