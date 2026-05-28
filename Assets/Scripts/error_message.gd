extends Control

@onready var error_message: Label = $ErrorPopUp/ErrorMessage

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func set_error_message(text):
	error_message.text = text

func _on_acknowledge_btn_button_up() -> void:
	queue_free()
