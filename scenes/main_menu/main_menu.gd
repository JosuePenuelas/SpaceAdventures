extends Control

@onready var star = $TitleVBoxContainer/TitleLabel/StarAnimatedSprite
# Called when the node enters the scene tree for the first time.
func _ready():
	star.play()
	$TitleVBoxContainer/ButtonsVBoxContainer/StartButton.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
