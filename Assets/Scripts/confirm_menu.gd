extends Control

signal confirmed

func _on_confirm_button_up() -> void:
	confirmed.emit(true)
	close_menu()

func _on_cancel_button_up() -> void:
	confirmed.emit(false)
	close_menu()

func close_menu():
	visible = false
