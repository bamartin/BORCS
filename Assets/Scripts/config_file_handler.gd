extends Node

var config = ConfigFile.new()
const SETTINGS_FILE_PATH = "user://BORCSettings.ini"
#C:\Users\bmart\AppData\Roaming\Godot\app_userdata\BORCS!

func _ready() -> void:
	if !FileAccess.file_exists(SETTINGS_FILE_PATH):
		config.set_value("keybinding", "slide_left", "A")
		config.set_value("keybinding", "slide_right", "D")
		
		config.set_value("level_avail", "level_1", false)
		
		config.set_value("player_stats", "coins", 0)
		config.set_value("player_stats", "score", 0)
		config.set_value("player_stats", "health", 100)
		
		config.save(SETTINGS_FILE_PATH)
	else:
		config.load(SETTINGS_FILE_PATH)


func save_keybinding_settings(key: String, value):
	config.set_value("keybinding", key, value)
	config.save(SETTINGS_FILE_PATH)

func load_keybinding_settings():
	var keybind_settings = {}
	for key in config.get_section_keys("keybinding"):
		keybind_settings[key] = config.get_value("keybinding", key)
	
	return keybind_settings

func save_level_avail(key: String, value):
	config.set_value("level_avail", key, value)
	config.save(SETTINGS_FILE_PATH)

func load_level_avail():
	var level_avail = {}
	for level in config.get_section_keys("level_avail"):
		level_avail[level] = config.get_value("level_avail", level, 1)
		print("Retrieved: " + str(level) + " " + str(level_avail[level]))
	
	return level_avail

func reset_level_avail():
	for level in config.get_section_keys("level_avail"):
		save_level_avail(level, false)

func save_coins(coins):
	config.set_value("player_stats", "coins", coins)
	config.save(SETTINGS_FILE_PATH)

func load_coins():
	return config.get_value("player_stats", "coins", 0)

func save_player_score(score):
	config.set_value("player_stats", "score", score)
	config.save(SETTINGS_FILE_PATH)

func load_player_score():
	return config.get_value("player_stats", "score", 0)

func save_player_health(health):
	config.set_value("player_stats", "health", health)
	config.save(SETTINGS_FILE_PATH)

func load_player_health():
	return config.get_value("player_stats", "health", 100)

func save_player_stats():
	save_player_score(GlobalVariables.player_score)
	save_coins(GlobalVariables.player_coins)
	save_player_health(GlobalVariables.player_health)
	config.save(SETTINGS_FILE_PATH)

func load_player_stats():
	GlobalVariables.set_coin_count(config.get_value("player_stats", "coins", 0))
	GlobalVariables.set_player_health(config.get_value("player_stats", "health", 100))
	GlobalVariables.set_player_score(config.get_value("player_stats", "score", 0))
