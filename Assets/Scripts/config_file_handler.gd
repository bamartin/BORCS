extends Node

const SETTINGS_FILE_PATH = "user://BORCSettings.ini"
const SAVE_FILE_DIR = "user://save/"
const SAVE_FILE_TYPE = ".sav"

var config_file = ConfigFile.new()
var save_file = ConfigFile.new()
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
		config_file.set_value("keybinding", "slide_left", "A")
		config_file.set_value("keybinding", "slide_right", "D")
		
		#Sound configurations
		config_file.set_value("sound_settings", "master_vol", 1)
		config_file.set_value("sound_settings", "sound_effects_vol", 1)
		config_file.set_value("sound_settings", "music_vol", 1)
		
		#Set save file settings
		config_file.set_value("save_data", "active_save", GlobalVariables.active_save)
		update_save_file_path()
		
		#If new settings file, then likely there are no saved games
		#Modify later to check for saved games first
		config_file.save(SETTINGS_FILE_PATH)
	else:
		config_file.load(SETTINGS_FILE_PATH)
		
		#Load the save game the config file points to
		GlobalVariables.active_save = config_file.get_value("save_data", "active_save", "")
		update_save_file_path()
		save_file.load(SAVE_FILE_PATH)
	
	update_global_variables()

func create_save_file(save_game_name):
	save_file.set_value("player_stats", "coins", 0)
	save_file.set_value("player_stats", "score", 0)
	save_file.set_value("player_stats", "health", 100)
	
	save_file.set_value("level_avail", "level_1", true)
	save_file.set_value("level_avail", "level_2", false)
	save_file.set_value("level_avail", "level_3", false)
	save_file.set_value("level_avail", "level_4", false)
	
	if save_game_name:
		GlobalVariables.active_save = save_game_name
		update_save_file_path()
		save_file.save(SAVE_FILE_PATH)
	else:
		GlobalVariables.active_save = "new_game"
		update_save_file_path()
		save_file.save(SAVE_FILE_PATH)
	
	config_file.save(SETTINGS_FILE_PATH)

func load_save_file():
	update_save_file_path()
	if FileAccess.file_exists(SAVE_FILE_PATH):
		config_file.set_value("save_data", "active_save", GlobalVariables.active_save)
		save_file.load(SAVE_FILE_PATH)
		config_file.save(SETTINGS_FILE_PATH)
	else:
		save_file.set_value("player_stats", "coins", 0)
		save_file.set_value("player_stats", "score", 0)
		save_file.set_value("player_stats", "health", 100)
		save_file.set_value("level_avail", "level_1", true)	

func save_keybinding_settings(key: String, value):
	config_file.set_value("keybinding", key, value)
	config_file.save(SETTINGS_FILE_PATH)

func load_keybinding_settings():
	var keybind_settings = {}
	for key in config_file.get_section_keys("keybinding"):
		keybind_settings[key] = config_file.get_value("keybinding", key)
	
	return keybind_settings

func save_sound_settings(key: String, value):
	config_file.set_value("sound_settings", key, value)
	config_file.save(SETTINGS_FILE_PATH)

func load_sound_settings():
	var sound_settings = {}
	for key in config_file.get_section_keys("sound_settings"):
		sound_settings[key] = config_file.get_value("sound_settings", key)
	
	return sound_settings

func save_level_avail(key: String, value):
	save_file.set_value("level_avail", key, value)	
	save_file.save(SAVE_FILE_PATH)

func load_level_avail():
	var level_avail = {}
	var count = 1
	update_save_file_path()
	print("Loading levels from: " + SAVE_FILE_PATH)
	for level in save_file.get_section_keys("level_avail"):
		level_avail[level] = save_file.get_value("level_avail", level, "level_1")
		print("Retrieved: " + str(level) + " " + str(level_avail[level]))
		if level_avail[level]:
			GlobalVariables.latest_level_num = count
			count += 1
	
	return level_avail

func reset_level_avail():
	if GlobalVariables.active_save != "":
		GlobalVariables.current_level_num = 1
		GlobalVariables.latest_level_num = 1
		for level in save_file.get_section_keys("level_avail"):
			save_level_avail(level, false)
	else:
		print("No active save, cannot reset progress")

func save_coins(coins):
	save_file.set_value("player_stats", "coins", coins)
	save_file.save(SAVE_FILE_PATH)

func load_coins():
	return save_file.get_value("player_stats", "coins", 0)

func save_player_score(score):
	save_file.set_value("player_stats", "score", score)
	save_file.save(SAVE_FILE_PATH)

func load_player_score():
	return save_file.get_value("player_stats", "score", 0)

func save_player_health(health):
	save_file.set_value("player_stats", "health", health)
	save_file.save(SAVE_FILE_PATH)

func load_player_health():
	return save_file.get_value("player_stats", "health", 100)

func save_player_stats():
	save_player_score(GlobalVariables.player_score)
	save_coins(GlobalVariables.player_coins)
	save_player_health(GlobalVariables.player_health)
	update_save_file_path()
	save_file.save(SAVE_FILE_PATH)

func load_player_stats():
	GlobalVariables.set_coin_count(save_file.get_value("player_stats", "coins", 0))
	GlobalVariables.set_player_health(save_file.get_value("player_stats", "health", 100))
	GlobalVariables.set_player_score(save_file.get_value("player_stats", "score", 0))

func update_save_file_path():
	SAVE_FILE_PATH = SAVE_FILE_DIR + GlobalVariables.active_save + SAVE_FILE_TYPE

func update_global_variables():
	var sound_settings = load_sound_settings()
	print(str(sound_settings))
	GlobalVariables.master_vol = sound_settings["master_vol"]
	GlobalVariables.sound_effects_vol = sound_settings["sound_effects_vol"]
	GlobalVariables.music_vol = sound_settings["music_vol"]
