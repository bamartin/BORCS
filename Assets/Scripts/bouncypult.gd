class_name Bouncypult

extends StaticBody2D

@export var SPEED = 500.0
@export var rotate_max = 25
var velocity: Vector2
var pos_y
var mouse_pos = Vector2(0,0)
@onready var bouncypult_node: Node2D = $".."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pos_y = position.y

func _physics_process(delta):
	if GlobalVariables.level_begin:
		var direction := Input.get_axis("Slide_Left", "Slide_Right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			
		var bouncypult_rotate := Input.get_axis("Rotate_Left", "Rotate_Right")
		if bouncypult_rotate:
			rotation_degrees += bouncypult_rotate
			if rotation_degrees >= rotate_max:
				rotation_degrees = rotate_max
			elif rotation_degrees <= -rotate_max:
				rotation_degrees = -rotate_max
			
		var collision = move_and_collide(velocity * delta)
		if collision and collision.get_collider() is not Ball:
			velocity.x = velocity.slide(collision.get_normal()).x
			
		if Input.is_action_just_pressed("Reset_Bar_Rotation"):
			rotation = 0
			
		position.y = pos_y

func get_pos():
	return Vector2(global_position.x, global_position.y)

func get_rot():
	return rotation
