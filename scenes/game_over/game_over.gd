extends Control


func _ready():
	SignalManager.on_game_over.connect(on_game_over)

func on_game_over():
	show()
	Engine.time_scale = 0

func _process(delta):
	pass

func _on_continue_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")
	SignalManager.reload_lives.emit()

func _on_exit_button_pressed():
	get_tree().quit()

