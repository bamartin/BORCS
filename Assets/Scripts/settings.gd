extends Control

@onready var confirm_menu: Control = $ConfirmMenu

var keybind_settings = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	keybind_settings = ConfigFileHandler.load_keybinding_settings()

func _on_back_button_up() -> void:
	get_tree().change_scene_to_file("res://Assets/Menus/main_menu.tscn")

func _on_levels_reset_button_up() -> void:
	confirm_menu.visible = true

func _on_confirm_menu_confirmed(confirmation) -> void:
	if confirmation:
		print("Reset levels")
		ConfigFileHandler.reset_level_avail()
	else:
		print("Cancel level reset")
