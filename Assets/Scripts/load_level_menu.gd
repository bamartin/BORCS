extends Control

@onready var load_level_menu: Control = $"."
@onready var levels: Control = $TextureRect/Levels

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var level_avail = ConfigFileHandler.load_level_avail()
	var i = 1
	var button_offset = 0
	
	#Use array pulled from config file to show the level selection buttons
	for level in level_avail:
		if level_avail[level]:
			print("Retrieved: " + str(level) + " " + str(level_avail[level]))
			var button = Button.new()
			button.pressed.connect(load_level.bind(i))
			button.text = "Level " + str(i)
			button.theme = load("res://Assets/Menus/Button.tres")
			button.position = Vector2(160, button_offset) #In future make this a relative number
			button_offset += 50 #In future make this a relative number
			levels.add_child(button)
		i += 1

func load_level(i):
	GlobalVariables.current_scene = "res://Levels/level_" + str(i) + ".tscn"
	print(GlobalVariables.current_scene)
	GlobalVariables.current_level_num = i
	get_tree().change_scene_to_file(GlobalVariables.current_scene)

func _on_back_button_up() -> void:
	get_tree().change_scene_to_file("res://Assets/Menus/main_menu.tscn")
