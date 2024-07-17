extends Node2D

@onready var player = $Player
@onready var player_cam = $Camera2D

var paused = false

func _ready():
	pass

func _physics_process(delta):
	player_cam.position = player.position
