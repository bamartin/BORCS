extends Control

const SOUND_SETTINGS = preload("uid://dkm5oyrjpllgp")

var keybind_settings = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	keybind_settings = ConfigFileHandler.load_keybinding_settings()

func _on_sound_button_up() -> void:
	var sound_settings_menu = SOUND_SETTINGS.instantiate()
	add_child(sound_settings_menu)

func _on_back_button_up() -> void:
	visible = false
