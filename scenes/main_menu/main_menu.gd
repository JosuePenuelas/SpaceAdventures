extends Control

@onready var star = $TitleVBoxContainer/TitleLabel/StarAnimatedSprite
@onready var blip_select = $BlipSelect
@onready var blip_pressed = $BlipPressed
@onready var start_button = $TitleVBoxContainer/ButtonsVBoxContainer/StartButton
@onready var exit_button = $TitleVBoxContainer/ButtonsVBoxContainer/ExitButton
@onready var music = $AudioStreamPlayer2D
@onready var select_sprite = $SelectSprite

var option : int = 0

func _ready():
	star.play()
	music.play()
	$TitleVBoxContainer/ButtonsVBoxContainer/StartButton.grab_focus()

func _input(event):
	if event.is_action_pressed("movement_up"):
		start_button.grab_focus()
	elif event.is_action_pressed("movement_down"):
		exit_button.grab_focus()

func _on_start_button_pressed():
	blip_pressed.play()

func _on_exit_button_pressed():
	blip_pressed.play()
	option = 1

func _on_start_button_focus_entered():
	exit_button.icon = null
	start_button.icon = preload("res://assets/GUI/Icon_arrow_right.png")
	blip_select.play()

func _on_exit_button_focus_entered():
	start_button.icon = null
	exit_button.icon = preload("res://assets/GUI/Icon_arrow_right.png")
	blip_select.play()

func _on_blip_pressed_finished():
	if option == 0:
		get_tree().change_scene_to_file("res://scenes/level_test/level_test.tscn")
		Engine.time_scale = 1
	elif option == 1:
		get_tree().quit()

func _on_audio_stream_player_2d_finished():
	music.play()
