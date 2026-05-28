class_name Breakable

extends StaticBody2D

@onready var wall: Node2D = $".."

func break_object(damage: int):
	wall.break_object(damage)

func score():
	wall.score()

func remove():
	wall.remove()

func shove(movement):
	get_parent().shove(movement)

func get_y():
	return global_position.y

func get_moveable():
	return get_parent().is_moveable

func set_moveable(moveable: bool):
	get_parent().is_moveable = moveable

func get_height():
	return get_parent().get_height()
