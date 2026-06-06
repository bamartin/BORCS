extends Node2D

@onready var ball: Ball = $Ball

var level : Node2D

func set_velocity(vel : Vector2):
	ball.linear_velocity = vel

func set_pos(pos : Vector2):
	ball.position = pos

func get_velocity():
	return ball.linear_velocity

func get_pos():
	return ball.position

func set_level(obj):
	level = obj

func launch_ball(vel : Vector2):
	ball.launch_ball(vel)

func ball_reset():
	level.ball_reset()

func get_init_speed():
	return ball.init_speed

func get_max_speed():
	return ball.max_speed

func set_max_speed(speed):
	ball.max_speed = speed

func get_min_speed():
	return ball.min_speed

func set_min_speed(speed):
	ball.min_speed = speed

func freeze():
	ball.freeze = true

func unfreeze():
	ball.freeze = false

func update_sound_settings():
	if ball:
		ball.update_sound_settings()
