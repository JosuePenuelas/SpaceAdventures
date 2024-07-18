extends Node

const SOUND_JUMP = "jump"
const SOUND_HURT = "hurt"
const SOUND_LAND = "land"
const SOUND_DEATH = "death"
const SOUND_ATTACK = "attack"
const SOUND_PICKUP = "pickup"
const SOUND_PAUSE = "pause"

var SOUNDS = {
	SOUND_JUMP : preload("res://assets/sounds/Jump.wav"),
	SOUND_HURT : preload("res://assets/sounds/Hit_Hurt_player.wav"),
	SOUND_DEATH : preload("res://assets/sounds/death.wav"),
	SOUND_LAND : preload("res://assets/sounds/land.wav"),
	SOUND_ATTACK : preload("res://assets/sounds/Laser_Shoot_player.wav"),
}

const SOUNDS_ENEMY_DEATH = "death_enemy"
const SOUNDS_ENEMY_ATTACK = "attack_enemy"
const SOUNDS_ENEMY_HURT = "hurt_enemy"

var SOUNDS_ENEMY = {
	SOUNDS_ENEMY_HURT : preload("res://assets/sounds/Hit_Hurt_enemy.wav"),
	SOUNDS_ENEMY_DEATH : preload("res://assets/sounds/death.wav"),
	SOUNDS_ENEMY_ATTACK : preload("res://assets/sounds/Laser_Shoot_enemy.wav"),
}

func play_clip(audio_player: AudioStreamPlayer2D, clip: String):
	if SOUNDS.has(clip):
		audio_player.stream = SOUNDS[clip]
		audio_player.play()
	elif SOUNDS_ENEMY.has(clip):
		audio_player.stream = SOUNDS_ENEMY[clip]
		audio_player.play()
