extends Node

var global_lives: float = 5
var global_score : int = 0

func _ready():
	SignalManager.on_damage.connect(on_damage)

func on_damage():
	global_lives -= 0.5
	SignalManager.on_update_lives_hud.emit()
