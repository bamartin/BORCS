class_name Enemy

extends RigidBody2D

@export var SPEED_X = 0
@export var SPEED_Y = 100
@export var min_speed = 50
@export var max_speed = 500

@onready var slow_timer: Timer = $"../SlowTimer"

var on_screen = false

func _ready() -> void:
	# Set velocity of enemy
	linear_velocity = Vector2(SPEED_X, SPEED_Y)
	position = Vector2(randi_range(260,840), 0) #Randomize enemy spawn location at top of screen
	#position = Vector2(550, 0) #Sets enemy spawn to center screen every time. For testing purposes only

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

func delete_enemy(points):
	GlobalVariables.player_score += points
	print("Score + " + str(points))
	get_parent().queue_free()

func _on_body_entered(body: Node) -> void:
	if body is Wall:
		print("Enemy y-pos: " + str(global_position.y))
		print("Breakable y-pos: " + str(body.get_y()))
		if global_position.y < body.get_y():
			print("Enemy shoves breakable")
			body.shove()
		else:
			print("Enemy Hit Breakable")
			body.break_object(1)
