extends Node

@onready var error_obj: PackedScene = preload("res://Assets/Menus/error_message.tscn")

#Config var
var mouse_moves_bouncypult: bool
var active_save = ""
var master_vol = 100
var sound_effects_vol = 100
var music_vol = 100

#Player stat var
var player_score = 0
var player_health = 100
var player_max_health = 100
var player_coins = 0

#Level var
var current_scene = ""
var breakables_remaining = 0
var level_begin = false
var current_level_num = 0
var latest_level_num = 0
var resetting_level = false
var reloading = false
var ball_launched = false
var init_ball_pos = Vector2(0,0)

func _ready() -> void:
	pass

func _process(_delta):
	pass

func inc_player_score(add):
	player_score += add

func update_player_health(update):
	player_health += update

func reset_variables():
	load_player_stats()
	ball_launched = false
	level_begin = false

func save_player_stats():
	ConfigFileHandler.save_player_stats()

func load_player_stats():
	ConfigFileHandler.load_player_stats()

func pause_game():
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func resume_game():
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
	get_tree().paused = false

func reset_level():
	resetting_level = true
	reset_variables()

func set_current_scene():
	current_scene = "res://Levels/level_" + str(current_level_num) + ".tscn"

func set_coin_count(coins):
	player_coins = coins

func add_coin():
	player_coins += 1

func get_coin_count():
	return player_coins

func get_player_score():
	return player_score

func set_player_score(score):
	player_score = score

func get_player_health():
	return player_health

func set_player_health(health):
	player_health = health

func error_popup(error_text):
	var error = error_obj.instantiate()
	get_parent().add_child(error)
	error.set_error_message(error_text)

func update_sound_settings():
	var sound_settings = ConfigFileHandler.load_sound_settings()
	for key in sound_settings:
		if key == "master_vol":
			master_vol = sound_settings[key]
		elif key == "sound_effects_vol":
			sound_effects_vol = sound_settings[key]
		elif key == "music_vol":
			music_vol = sound_settings[key]
