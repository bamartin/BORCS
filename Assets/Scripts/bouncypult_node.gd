extends Node2D

@onready var bouncypult: Bouncypult = $Bouncypult
@onready var bouncypult_sprite: AnimatedSprite2D = $Bouncypult/BouncypultSprite
@onready var spawn_point: Node2D = $Bouncypult/SpawnPoint

var level : Node2D

func get_pos():
	return Vector2(bouncypult.global_position.x, bouncypult.global_position.y)

func get_rot():
	return bouncypult.rotation

func get_bouncypult():
	return bouncypult

func get_ball_spawn_point():
	return spawn_point.global_position

func set_level(obj):
	level = obj

func _on_squash_zone_body_entered(body: Node2D) -> void:
	if GlobalVariables.ball_launched:
		bouncypult_sprite.speed_scale = body.linear_velocity.y/150
		bouncypult_sprite.play()
		print("Compressing sprite")
		if body is Ball or body is Enemy:
			print("Object speed before collision: " + str(body.linear_velocity))
			body.linear_velocity = body.linear_velocity * 1.1
			print("Object speed after collision: " + str(body.linear_velocity))
	elif GlobalVariables.level_begin:
		bouncypult_sprite.play()
		level.ball_launch()
