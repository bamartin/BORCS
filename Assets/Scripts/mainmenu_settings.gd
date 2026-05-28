extends Control

#@onready var confirm_menu: Control = $ConfirmMenu

const SOUND_SETTINGS = preload("uid://dkm5oyrjpllgp")
const CONFIRM_MENU = preload("uid://dhwsi3niwmgfh")

var keybind_settings = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	keybind_settings = ConfigFileHandler.load_keybinding_settings()

func _on_back_button_up() -> void:
	get_tree().change_scene_to_file("res://Assets/Menus/main_menu.tscn")

func _on_levels_reset_button_up() -> void:
	var confirm_menu = CONFIRM_MENU.instantiate()
	add_child(confirm_menu)

func _on_confirm_menu_confirmed(confirmation) -> void:
	if confirmation:
		print("Reset levels")
		ConfigFileHandler.reset_level_avail()
	else:
		print("Cancel level reset")


func _on_sound_settings_button_up() -> void:
	var sound_settings_menu = SOUND_SETTINGS.instantiate()
	add_child(sound_settings_menu)
