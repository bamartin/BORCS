extends Node2D

@onready var pause_menu: Control = $MenuLayer/PauseMenu
@onready var breakables: Node2D = $Objects/Breakables
@onready var bouncypult: Node2D = $Objects/Bouncypult
@onready var objects_node: CanvasLayer = $Objects
@onready var level_variables: Node = $LevelVariables
@onready var hud: Control = $MenuLayer/HUD
@onready var ball_obj: PackedScene = preload("res://Assets/ball.tscn")
@onready var enemy_obj: PackedScene = preload("res://Assets/enemy.tscn")
@onready var coin_obj: PackedScene = preload("res://Assets/coin.tscn")
@onready var reset_timer: Timer = $ResetTimer

var ball : Node2D

@export var next_level : PackedScene = null
@export var is_final_level : bool = false
#@export var ball_pos = Vector2(0,0)


func _ready() -> void:
	#Get current system time for debug log messages
	var time = Time.get_datetime_dict_from_system()
	var _debug_time = str(time.hour) + ":" + str(time.minute) + ":" + str(time.second)
	
	#Mouse is hidden and restricted to window while game is in progress
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED 
	get_tree().paused = false
	
	#Tie level object to the bouncypult to call functions
	bouncypult.set_level($".")
	
	#Once you start a level it becomes available in level selection
	ConfigFileHandler.save_level_avail("level_" + str(GlobalVariables.current_level_num), true)
	
	#Set initial level variables
	var breakables_in_level = breakables.get_child_count()
	GlobalVariables.breakables_remaining = breakables_in_level
	hud.update_stats()
	ball_init()
	
	hud.show_ready()
	await get_tree().create_timer(1).timeout
	hud.hide_ready()
	
	#Set level variables
	GlobalVariables.load_player_stats()
	GlobalVariables.player_health = GlobalVariables.player_max_health
	GlobalVariables.level_begin = true
	GlobalVariables.ball_launched = false
	GlobalVariables.resetting_level = false
	GlobalVariables.reloading = false
	GlobalVariables.resume_game()
	
	hud.show_begin()
	await get_tree().create_timer(.5).timeout
	hud.hide_begin()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("Menu") and not GlobalVariables.reloading:
		if GlobalVariables.level_begin:
			PauseMenu()
	elif Input.is_action_just_pressed("Launch") and not GlobalVariables.ball_launched:
		ball_launch()

func PauseMenu():
	if not get_tree().paused:
		GlobalVariables.pause_game()
		pause_menu.visible = true
		print("Pause from key press")
	else:
		GlobalVariables.resume_game()
		pause_menu.visible = false
		print("Unpause from key press")

func _on_breakables_child_exiting_tree(node: Node) -> void:
	#If the level isn't being reset
	if not GlobalVariables.resetting_level:
		#Create coin when breakable breaks
		var pos = node.global_position
		print("Object broken at position: " + str(pos))
		var coin = coin_obj.instantiate()
		coin.global_position = pos
		objects_node.add_child(coin)
		print("Coin created")
		
		#Get current system time for debug log messages
		var time = Time.get_datetime_dict_from_system()
		var debug_time = str(time.hour) + ":" + str(time.minute) + ":" + str(time.second)
		print(debug_time + " Object Broken")
		
		#Broken objects should count towards score
		GlobalVariables.breakables_remaining -= 1
		print(debug_time + " Objects remaining: " + str(GlobalVariables.breakables_remaining))
		if GlobalVariables.breakables_remaining <= 0:
			level_win()
		
		hud.update_stats()

func level_win():
	#Get current system time for debug log messages
	var time = Time.get_datetime_dict_from_system()
	var debug_time = str(time.hour) + ":" + str(time.minute) + ":" + str(time.second)
	
	#Win level, add level score to global score, get the next level
	print(debug_time + " You Win!")
	GlobalVariables.pause_game()
	GlobalVariables.current_level_num += 1
	GlobalVariables.set_current_scene()
	GlobalVariables.level_begin = false
	ConfigFileHandler.save_player_stats()
	await get_tree().create_timer(1).timeout
	if is_final_level or next_level == null:
		get_tree().change_scene_to_file("res://Assets/Menus/main_menu.tscn")
	else:
		get_tree().change_scene_to_packed(next_level)

func ball_reset():
	#Reset ball. Should game be paused while doing this? Perhaps not?
	#GlobalVariables.pause_game() 
	GlobalVariables.reloading = true
	hud.show_reloading()
	ball.queue_free()
	await get_tree().create_timer(1).timeout
	ball_init()
	GlobalVariables.resume_game()
	hud.hide_reloading()

func _on_floor_body_entered(body: Node2D) -> void:
	if body is Ball:
		ball_reset()
	elif body is Enemy:
		print("Enemy made it past bouncypult, decrease health and delete enemy")
		body.delete_enemy(0)
		GlobalVariables.player_health -= 10
	elif body is Coin:
		print("Coin left screen, adding to loot")
		GlobalVariables.add_coin()
		body.delete_coin()
	
	hud.update_stats()

func ball_init():
	#Set initial ball position to be the ball spawn point for the level
	GlobalVariables.init_ball_pos = bouncypult.get_ball_spawn_point()
	print("Ball starting point: " + str(GlobalVariables.init_ball_pos))
	
	#Create ball and add as child of bouncypult, so it will move with the bouncypult until launch
	ball = ball_obj.instantiate()
	ball.set_level($".")
	bouncypult.get_bouncypult().add_child(ball)
	GlobalVariables.reloading = false
	ball.freeze()

func ball_launch():
	if GlobalVariables.level_begin:
		ball.call_deferred("reparent", objects_node)
		ball.call_deferred("unfreeze")
		ball.call_deferred("launch_ball", Vector2(sin(bouncypult.get_rot())*ball.get_init_speed(), -cos(bouncypult.get_rot())*ball.get_init_speed()))

# Create enemy unit and spawn at random position at the top of the screen
func spawn_enemy():
	var enemy = enemy_obj.instantiate()
	objects_node.add_child(enemy)
	print("Enemy created")
