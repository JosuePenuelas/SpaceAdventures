extends Node

const SOUND_JUMP = "jump"
const SOUND_HURT = "hurt"
const SOUND_LAND = "land"
const SOUND_PICKUP = "pickup"
const SOUND_PAUSE = "pause"

var SOUNDS = {}

func play_clip(audio_player: AudioStreamPlayer2D, clip: String):
	if SOUNDS.has(clip):
		audio_player.stream = SOUNDS[clip]
		audio_player.play()

func _ready():
	pass

func _process(delta):
	pass
