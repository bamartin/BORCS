extends Node2D

@onready var break_one: TextureRect = $Wall/WallSprite/BreakOne
@onready var break_two: TextureRect = $Wall/WallSprite/BreakTwo

var hits = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func break_object(damage):
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

func shove():
	position.y += 10

func score():
	GlobalVariables.inc_player_score(1)
	print("Adding 1 point")
	print("Current Score: " + str(GlobalVariables.player_score))

func remove():
	queue_free()
