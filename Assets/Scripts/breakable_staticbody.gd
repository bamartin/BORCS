class_name Wall

extends StaticBody2D

@onready var wall: Node2D = $".."

func break_object(damage):
	wall.break_object(damage)

func score():
	wall.score()

func remove():
	wall.remove()

func shove():
	get_parent().shove()

func get_y():
	return global_position.y
