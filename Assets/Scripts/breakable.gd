extends Node2D

@onready var break_one: TextureRect = $Breakable/BreakableSprite/BreakOne
@onready var break_two: TextureRect = $Breakable/BreakableSprite/BreakTwo
@onready var breakable_area_2d: Area2D = $BreakableArea2D
@onready var breakable_sprite: Sprite2D = $Breakable/BreakableSprite
@onready var breakable: Breakable = $Breakable

@export var is_moveable = true
@export var is_breakable = true

var hits = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func break_object(damage):
	if is_breakable:
		hits += damage
		print("Hits: " + str(hits))
		
		match hits:
			0:
				pass
			1:
				pass
			2:
				break_one.visible = true
			3:
				break_one.visible = true
			4:
				break_two.visible = true
			5:
				break_two.visible = true
			6:
				print("Break Object")
				remove()
				score()
			_:
				print("Max hits exceeded. Breaking Object.")
				remove()
				score()
	else:
		print("Object not currently breakable")

func shove(movement):
	if is_moveable:
		print("Breakable shove, initial position: " + str(global_position))
		move_local_y(movement)
		print("After shove position: " + str(global_position))
	else:
		print("Object not currently moveable")

func score():
	GlobalVariables.inc_player_score(1)
	print("Adding 1 point")
	print("Current Score: " + str(GlobalVariables.player_score))

func remove():
	queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	#Make sure the colliding body is another breakable and that it is not this object's Staticbody
	if body is Breakable and body != breakable:
		if body.get_moveable():
			print("Colliding with breakable, shoving breakable")
			body.shove(10)

func get_height():
	return breakable_sprite.scale.y * breakable_sprite.texture.get_height()


func _on_breakable_area_2d_body_exited(body: Node2D) -> void:
	if body is Breakable:
		print("collision exited")
