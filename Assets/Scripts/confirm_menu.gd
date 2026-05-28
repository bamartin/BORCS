extends Control

signal confirmed

func _on_confirm_button_up() -> void:
	confirmed.emit(true)
	queue_free()

func _on_cancel_button_up() -> void:
	confirmed.emit(false)
	queue_free()
