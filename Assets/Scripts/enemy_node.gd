extends Node2D

@onready var enemy: RigidBody2D = $Enemy

func _physics_process(_delta: float) -> void:
	pass

func set_pos(pos):
	enemy.position = pos

func get_pos():
	return enemy.position

func set_velocity(vel):
	enemy.velocity = vel

func get_velocity():
	return enemy.velocity

func set_on_screen(on_screen):
	enemy.on_screen = on_screen

func get_on_screen():
	return enemy.on_screen

func get_min_speed():
	return enemy.min_speed

func set_min_speed(speed):
	enemy.min_speed = speed

func get_max_speed():
	return enemy.max_speed

func set_max_speed(speed):
	enemy.max_speed = speed

func update_sound_settings():
	if enemy:
		enemy.update_sound_settings()
