extends Control

func _ready():
	SignalManager.on_pause.connect(on_pause)

func on_pause():
	show()  # Mostrar el menú de pausa
	Engine.time_scale = 0  # Detener el tiempo del juego
	get_tree().paused = false  # No pausar el árbol de nodos, solo el tiempo

func _process(delta):
	if Input.is_action_pressed("continue"):
		_on_continue_button_pressed()

func _on_continue_button_pressed():
	hide()  # Ocultar el menú de pausa
	Engine.time_scale = 1  # Reanudar el tiempo del juego
	get_tree().paused = false  # Reanudar el árbol de nodos

func _on_exit_button_pressed():
	get_tree().quit()  # Salir del juego

func _on_main_menu_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")
	SignalManager.reload_lives.emit()
