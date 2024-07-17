extends Control

@onready var lives_hud = $MarginContainer/HBoxContainer/LivesSprite
var num_frame_live : int = 0

func _ready():
	SignalManager.on_update_lives_hud.connect(on_update_lives_hud)
	SignalManager.on_game_over.connect(on_game_over)
	SignalManager.reload_lives.connect(reload_lives)

func on_update_lives_hud():
	num_frame_live += 1
	if num_frame_live >= lives_hud.vframes:
		num_frame_live = 10
	lives_hud.frame = num_frame_live

func on_game_over():
	lives_hud.visible = false

func reload_lives():
	num_frame_live = 0
