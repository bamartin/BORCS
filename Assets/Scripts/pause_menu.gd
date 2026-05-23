extends Control

@onready var settings_menu: Control = $InGame_Settings

func _on_resume_button_up() -> void:
	GlobalVariables.resume_game()
	visible = false


func _on_restart_button_up() -> void:
	GlobalVariables.reset_level()
	get_tree().change_scene_to_file(GlobalVariables.current_scene)


func _on_settings_button_up() -> void:
	settings_menu.visible = true


func _on_quit_button_up() -> void:
	GlobalVariables.resetting_level = true
	get_tree().quit()


func _on_main_menu_button_up() -> void:
	get_tree().paused = false
	GlobalVariables.resetting_level = true
	get_tree().change_scene_to_file("res://Assets/Menus/main_menu.tscn")
	
