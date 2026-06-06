class_name Coin

extends RigidBody2D

@export var SPEED_X = 0
@export var SPEED_Y = 100
@export var max_speed = 500
@export var min_speed = 50

@onready var slow_timer: Timer = $"../SlowTimer"

func _ready() -> void:
	# Set velocity of enemy
	linear_velocity = Vector2(SPEED_X, SPEED_Y)

func _process(_delta):
	if not get_tree().paused:
		if abs(linear_velocity.y) < min_speed and abs(linear_velocity.x) < min_speed and slow_timer.is_stopped():
			slow_timer.start()
		elif not slow_timer.is_stopped() and (abs(linear_velocity.y) >= min_speed or abs(linear_velocity.x) >= min_speed):
			slow_timer.stop()

func _integrate_forces(_state: PhysicsDirectBodyState2D) -> void:
	if abs(linear_velocity.x) > max_speed:
		linear_velocity.x = (linear_velocity.x/abs(linear_velocity.x)) * max_speed
	
	if abs(linear_velocity.y) > max_speed:
		linear_velocity.y = (linear_velocity.y/abs(linear_velocity.y)) * max_speed

func delete_coin():
	print("Deleting coin")
	get_parent().queue_free()


func _on_slow_timer_timeout() -> void:
	print("Coin speed too slow")
	delete_coin()

func update_sound_settings():
	pass
	#print("Updating coin sound to " + str(bounce_audio.volume_linear))
