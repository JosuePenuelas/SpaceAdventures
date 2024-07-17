extends Node

var global_lives: float = 5
var global_score : int = 0

func _ready():
	SignalManager.on_damage.connect(on_damage)
	SignalManager.reload_lives.connect(reload_lives)

func on_damage():
	global_lives -= 0.5
	SignalManager.on_update_lives_hud.emit()
	if global_lives == 0:
		SignalManager.on_death.emit()

func reload_lives():
	global_lives = 5
	global_score = 0
