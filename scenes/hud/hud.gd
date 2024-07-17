extends Control

@onready var lives_hud = $MarginContainer/HBoxContainer/LivesSprite
var num_frame_live : int = 0

func _ready():
	SignalManager.on_update_lives_hud.connect(on_update_lives_hud)

func on_update_lives_hud():
	num_frame_live += 1
	if num_frame_live >= lives_hud.vframes:
		num_frame_live = 10
	lives_hud.frame = num_frame_live
