extends Control

@onready var new_game_obj: PackedScene = preload("res://Assets/Menus/new_game_create.tscn")
@onready var main_menu: TextureRect = $MainMenu
@onready var continue_btn: Button = $MainMenu/Continue

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalVariables.reset_variables()
	if GlobalVariables.active_save != "":
		continue_btn.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_new_game_button_up() -> void:
	var new_game_menu = new_game_obj.instantiate()
	new_game_menu.connect("game_named", start_new_game)
	main_menu.visible = false
	add_child(new_game_menu)
	
func start_new_game():
	GlobalVariables.current_scene = "res://Levels/level_1.tscn"
	GlobalVariables.current_level_num = 1
	get_tree().change_scene_to_file(GlobalVariables.current_scene)

func _on_load_level_button_up() -> void:
	get_tree().change_scene_to_file("res://Assets/Menus/load_level_menu.tscn")


func _on_settings_button_up() -> void:
	get_tree().change_scene_to_file("res://Assets/Menus/mainmenu_settings.tscn")


func _on_quit_button_up() -> void:
	get_tree().quit()


func _on_load_game_button_up() -> void:
	get_tree().change_scene_to_file("res://Assets/Menus/load_game.tscn")


func _on_continue_button_up() -> void:
	await ConfigFileHandler.load_save_file()
	await ConfigFileHandler.load_level_avail()
	GlobalVariables.current_level_num = GlobalVariables.latest_level_num
	GlobalVariables.current_scene = "res://Levels/level_" + str(GlobalVariables.latest_level_num) + ".tscn"
	get_tree().change_scene_to_file(GlobalVariables.current_scene)
