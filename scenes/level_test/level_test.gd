extends Node2D

@onready var player = $Player
@onready var player_cam = $Camera2D
@onready var music = $MusicLevel
@onready var level_number = $CanvasLayer/LevelNumber
@onready var timer_level_number = $LevelNumberTimer
@onready var wait_timer_music = $MusicLevel/WaitTimer

func _ready():
	level_number.visible = true
	if wait_timer_music.is_stopped():
		music.play()
		get_tree().paused = true

func _physics_process(delta):
	player_cam.position = player.position

func _on_audio_stream_player_2d_finished():
	wait_timer_music.start()
	

func _on_level_number_timer_timeout():
	print("se acabo el timer")
	get_tree().paused = false
	level_number.visible = false
	music.play()
