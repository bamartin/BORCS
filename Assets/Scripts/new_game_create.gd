extends Control

@onready var save_game_name: LineEdit = $TextureRect/SaveGameName

signal game_named

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_ok_button_up() -> void:
	if save_game_name.text != "":
		await ConfigFileHandler.create_save_file(save_game_name.text)
		game_named.emit()
		queue_free()
	else:
		GlobalVariables.error_popup("Please enter a name for your save")
		
