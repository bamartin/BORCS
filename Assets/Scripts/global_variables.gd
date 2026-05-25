extends Node

var mouse_moves_bouncypult: bool
var player_score = 0
var player_health = 100
var player_max_health = 100
var player_coins = 0
var current_scene = ""
var breakables_remaining = 0
var level_begin = false
var current_level_num = 0
var latest_level_num = 0
var resetting_level = false
var reloading = false
var ball_launched = false
var init_ball_pos = Vector2(0,0)
var active_save = ""

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
