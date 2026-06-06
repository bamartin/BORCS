extends Node2D

@onready var coin: Coin = $Coin



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func get_min_speed():
	return coin.min_speed

func set_min_speed(speed):
	coin.min_speed = speed

func get_max_speed():
	return coin.max_speed

func set_max_speed(speed):
	coin.max_speed = speed

func update_sound_settings():
	if coin:
		coin.update_sound_settings()
