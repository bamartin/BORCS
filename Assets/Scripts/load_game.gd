extends Control

@onready var games: Control = $LoadGameBackground/Games

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var dir = DirAccess.open(ConfigFileHandler.SAVE_FILE_DIR)
	if dir:
		dir.list_dir_begin()
		var save_file = dir.get_next()
		var button_offset = 0
		
		while save_file != "":
			if dir.current_is_dir():
				pass
			elif save_file.contains(".sav"):
				print("Found save file: " + str(save_file))
				var button = Button.new()
				button.pressed.connect(load_game.bind(save_file))
				button.text = str(save_file.left(-4))
				button.theme = load("res://Assets/Menus/Button.tres")
				button.position = Vector2(160, button_offset) #In future make this a relative number
				button_offset += 50 #In future make this a relative number
				games.add_child(button)
				save_file = dir.get_next()
	else:
		print("Error opening directory")

func load_game(game: String):
	GlobalVariables.active_save = game.left(-4)
	ConfigFileHandler.load_save_file()
	get_tree().change_scene_to_file("res://Assets/Menus/main_menu.tscn")

func _on_back_button_up() -> void:
	get_tree().change_scene_to_file("res://Assets/Menus/main_menu.tscn")
