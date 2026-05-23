extends Control

@onready var reloading_lbl: Label = $Messages/Reloading
@onready var ready_lbl: Label = $Messages/Ready
@onready var begin_lbl: Label = $Messages/Begin
@onready var slow_lbl: Label = $Messages/BallToSlow
@onready var health: Label = $PlayerUI/Health_lbl/Health
@onready var score: Label = $PlayerUI/Score_lbl/Score
@onready var level: Label = $PlayerUI/Level
@onready var coins: Label = $PlayerUI/Coins_lbl/Coins

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_stats()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	update_stats()

func update_stats():
	set_lvl_text()
	set_health()
	set_score()
	set_coin_count()

func show_reloading():
	reloading_lbl.visible = true

func hide_reloading():
	reloading_lbl.visible = false

func show_ready():
	ready_lbl.visible = true

func hide_ready():
	ready_lbl.visible = false

func show_begin():
	begin_lbl.visible = true

func hide_begin():
	begin_lbl.visible = false

func show_slow():
	slow_lbl.visible = true

func hide_slow():
	slow_lbl.visible = false

func set_lvl_text():
	level.text = "Level: " + str(GlobalVariables.current_level_num)

func set_coin_count():
	coins.text = str(GlobalVariables.get_coin_count())

func set_score():
	score.text = str(GlobalVariables.get_player_score())

func set_health():
	health.text = str(GlobalVariables.get_player_health())
