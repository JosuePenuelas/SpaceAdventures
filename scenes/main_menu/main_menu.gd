extends Control

@onready var star = $TitleVBoxContainer/TitleLabel/StarAnimatedSprite
# Called when the node enters the scene tree for the first time.
func _ready():
	star.play()
	$TitleVBoxContainer/ButtonsVBoxContainer/StartButton.grab_focus()



func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://scenes/level_test/level_test.tscn")
	Engine.time_scale = 1

func _on_exit_button_pressed():
	get_tree().quit()
