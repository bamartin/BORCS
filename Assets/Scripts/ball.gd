class_name Ball

extends RigidBody2D

var init_speed = 150
@export var max_speed = 500
@export var min_speed = 50 #Used in level script to reset ball if too slow

@onready var reset_timer: Timer = $"../ResetTimer"

var current_speed: Vector2

func _ready() -> void:
	GlobalVariables.ball_launched = false
	linear_velocity = Vector2(0,0)
	global_position = GlobalVariables.init_ball_pos

func _process(_delta):
	if GlobalVariables.ball_launched and not get_tree().paused and not GlobalVariables.reloading:
		if abs(linear_velocity.y) < min_speed and abs(linear_velocity.x) < min_speed and reset_timer.is_stopped():
			print("Ball speed: (" + str(linear_velocity) + ")")
			print("ball is too slow, resetting")
			reset_timer.start()
		elif not reset_timer.is_stopped() and (abs(linear_velocity.y) >= min_speed or abs(linear_velocity.x) >= min_speed):
			print("Ball velocity increased, stopping reset timer")
			reset_timer.stop()

func _integrate_forces(_state: PhysicsDirectBodyState2D) -> void:
	if abs(linear_velocity.x) > max_speed:
		linear_velocity.x = (linear_velocity.x/abs(linear_velocity.x)) * max_speed
	
	if abs(linear_velocity.y) > max_speed:
		linear_velocity.y = (linear_velocity.y/abs(linear_velocity.y)) * max_speed
	
	#print(str(linear_velocity))

func launch_ball(vel : Vector2):
	linear_velocity = vel
	GlobalVariables.ball_launched = true
	var time = Time.get_datetime_dict_from_system()
	var debug_time = str(time.hour) + ":" + str(time.minute) + ":" + str(time.second)
	print(debug_time + " Ball launched")

func _on_body_entered(body: Node) -> void:
	if body is Wall:
		print("Ball Hit Breakable")
		body.break_object(2)
	elif body is Enemy:
		print("Destroying Enemy")
		body.delete_enemy(1)

func _on_reset_timer_timeout() -> void:
	if abs(linear_velocity.y) < 50 and abs(linear_velocity.x) < 50:
		get_parent().ball_reset()
