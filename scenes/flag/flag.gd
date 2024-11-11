extends Area2D

@onready var animatedSprite2D = $AnimatedSprite2D

func _ready():
	pass # Replace with function body.


func _process(delta):
	pass


func _on_area_entered(area):
	print("Jugador llego al final")
	animatedSprite2D.play()
	

func _on_animated_sprite_2d_animation_finished():
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")
	SignalManager.reload_lives.emit()

