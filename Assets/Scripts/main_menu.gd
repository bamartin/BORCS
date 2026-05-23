extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalVariables.reset_variables()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_new_game_button_up() -> void:
	GlobalVariables.current_scene = "res://Levels/level_1.tscn"
	GlobalVariables.current_level_num = 1
	get_tree().change_scene_to_file(GlobalVariables.current_scene)


func _on_load_level_button_up() -> void:
	get_tree().change_scene_to_file("res://Assets/Menus/load_level_menu.tscn")


func _on_settings_button_up() -> void:
	get_tree().change_scene_to_file("res://Assets/Menus/mainmenu_settings.tscn")


func _on_quit_button_up() -> void:
	get_tree().quit()
