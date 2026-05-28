extends Node

const SETTINGS_FILE_PATH = "user://BORCSettings.ini"
const SAVE_FILE_DIR = "user://save/"
const SAVE_FILE_TYPE = ".sav"

var config = ConfigFile.new()
var save = ConfigFile.new()
var SAVE_FILE_PATH = ""
#C:\Users\bmart\AppData\Roaming\Godot\app_userdata\BORCS!

func _ready() -> void:
	#Check if save directory exists
	if !DirAccess.open(SAVE_FILE_DIR):
		print("Creating save directory")
		DirAccess.make_dir_absolute(SAVE_FILE_DIR)
	
	#Check if config file exists, if not then create with default values
	if !FileAccess.file_exists(SETTINGS_FILE_PATH):
		#Keybinding configurations
		config.set_value("keybinding", "slide_left", "A")
		config.set_value("keybinding", "slide_right", "D")
		
		#Sound configurations
		config.set_value("sound_settings", "master_vol", 100)
		config.set_value("sound_settings", "sound_effects_vol", 100)
		config.set_value("sound_settings", "music_vol", 100)
		
		#Set save file settings
		config.set_value("save_data", "active_save", GlobalVariables.active_save)
		update_save_file_path()
		
		#If new settings file, then likely there are no saved games
		#Modify later to check for saved games first
		config.save(SETTINGS_FILE_PATH)
	else:
		config.load(SETTINGS_FILE_PATH)
		
		#Load the save game the config file points to
		GlobalVariables.active_save = config.get_value("save_data", "active_save", "")
		update_save_file_path()
		save.load(SAVE_FILE_PATH)

func create_save_file(save_game_name):
	save.set_value("player_stats", "coins", 0)
	save.set_value("player_stats", "score", 0)
	save.set_value("player_stats", "health", 100)
	
	save.set_value("level_avail", "level_1", true)
	save.set_value("level_avail", "level_2", false)
	save.set_value("level_avail", "level_3", false)
	save.set_value("level_avail", "level_4", false)
	
	if save_game_name:
		GlobalVariables.active_save = save_game_name
		update_save_file_path()
		save.save(SAVE_FILE_PATH)
	else:
		GlobalVariables.active_save = "new_game"
		update_save_file_path()
		save.save(SAVE_FILE_PATH)
	
	config.save(SETTINGS_FILE_PATH)

func load_save_file():
	update_save_file_path()
	if FileAccess.file_exists(SAVE_FILE_PATH):
		config.set_value("save_data", "active_save", GlobalVariables.active_save)
		save.load(SAVE_FILE_PATH)
		config.save(SETTINGS_FILE_PATH)
	else:
		save.set_value("player_stats", "coins", 0)
		save.set_value("player_stats", "score", 0)
		save.set_value("player_stats", "health", 100)
		save.set_value("level_avail", "level_1", true)	

func save_keybinding_settings(key: String, value):
	config.set_value("keybinding", key, value)
	config.save(SETTINGS_FILE_PATH)

func load_keybinding_settings():
	var keybind_settings = {}
	for key in config.get_section_keys("keybinding"):
		keybind_settings[key] = config.get_value("keybinding", key)
	
	return keybind_settings

func save_sound_settings(key: String, value):
	config.set_value("sound_settings", key, value)
	config.save(SETTINGS_FILE_PATH)

func load_sound_settings():
	var sound_settings = {}
	for key in config.get_section_keys("sound_settings"):
		sound_settings[key] = config.get_value("sound_settings", key)
	
	return sound_settings

func save_level_avail(key: String, value):
	save.set_value("level_avail", key, value)	
	save.save(SAVE_FILE_PATH)

func load_level_avail():
	var level_avail = {}
	var count = 1
	update_save_file_path()
	print("Loading levels from: " + SAVE_FILE_PATH)
	for level in save.get_section_keys("level_avail"):
		level_avail[level] = save.get_value("level_avail", level, "level_1")
		print("Retrieved: " + str(level) + " " + str(level_avail[level]))
		if level_avail[level]:
			GlobalVariables.latest_level_num = count
			count += 1
	
	return level_avail

func reset_level_avail():
	if GlobalVariables.active_save != "":
		GlobalVariables.current_level_num = 1
		GlobalVariables.latest_level_num = 1
		for level in save.get_section_keys("level_avail"):
			save_level_avail(level, false)
	else:
		print("No active save, cannot reset progress")

func save_coins(coins):
	save.set_value("player_stats", "coins", coins)
	save.save(SAVE_FILE_PATH)

func load_coins():
	return save.get_value("player_stats", "coins", 0)

func save_player_score(score):
	save.set_value("player_stats", "score", score)
	save.save(SAVE_FILE_PATH)

func load_player_score():
	return save.get_value("player_stats", "score", 0)

func save_player_health(health):
	save.set_value("player_stats", "health", health)
	save.save(SAVE_FILE_PATH)

func load_player_health():
	return save.get_value("player_stats", "health", 100)

func save_player_stats():
	save_player_score(GlobalVariables.player_score)
	save_coins(GlobalVariables.player_coins)
	save_player_health(GlobalVariables.player_health)
	update_save_file_path()
	save.save(SAVE_FILE_PATH)

func load_player_stats():
	GlobalVariables.set_coin_count(save.get_value("player_stats", "coins", 0))
	GlobalVariables.set_player_health(save.get_value("player_stats", "health", 100))
	GlobalVariables.set_player_score(save.get_value("player_stats", "score", 0))

func update_save_file_path():
	SAVE_FILE_PATH = SAVE_FILE_DIR + GlobalVariables.active_save + SAVE_FILE_TYPE
