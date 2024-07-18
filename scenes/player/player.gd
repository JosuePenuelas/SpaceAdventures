extends CharacterBody2D

@export var fire: PackedScene

@onready var anim_player = $AnimationPlayer
@onready var sprite2d = $Sprite2D
@onready var audio_player = $AudioStreamPlayer2D
@onready var shoot_marker = $Shoot
@onready var shoot_timer = $ShootTimer
@onready var animationShoot_timer = $AnimationShootTimer
@onready var invicible_timer = $InvincibleTimer

const MOVEMENT_SPEED: float = 130.0
const BOOSTED_SPEED: float = 240.0
const GRAVITY: float = 1000.0
const JUMP_FORCE: float = 350.0
const HURT_JUMP_FORCE: float = -200.0
const VELOCITY_SHOOT: float = 320.0

var on_shoot : bool = false
var is_invicible : bool = false
var is_death : bool = false
var stop : bool = false
var is_playing_sound : bool = false

var shoot_count : int = 0

enum PLAYER_STATES {IDLE, RUN, FALL, JUMP, HURT, SHOOT, RUNSHOOT, DEATH}
var current_state: PLAYER_STATES = PLAYER_STATES.IDLE

func _ready():
	SignalManager.on_death.connect(on_death)

func _physics_process(delta):
	if not is_on_floor():
		apply_gravity(delta)
	get_input()
	calculate_state()
	move_and_slide()

func calculate_state():
	if stop:
		return
	
	if is_death:
		set_state(PLAYER_STATES.DEATH)
		return
		
	if is_invicible:
		set_state(PLAYER_STATES.HURT)
	else:
		if is_on_floor():
			if velocity.x != 0:
				if on_shoot:
					set_state(PLAYER_STATES.RUNSHOOT)
				else:
					set_state(PLAYER_STATES.RUN)
			else:
				if on_shoot:
					set_state(PLAYER_STATES.SHOOT)
				else:
					set_state(PLAYER_STATES.IDLE)
		else:
			if velocity.y > 0:
				set_state(PLAYER_STATES.FALL)
			else:
				set_state(PLAYER_STATES.JUMP)

func set_state(new_state: PLAYER_STATES):
	if current_state == PLAYER_STATES.FALL and is_on_floor():
			SoundManager.play_clip(audio_player, SoundManager.SOUND_LAND)
	current_state = new_state
	match current_state:
		PLAYER_STATES.RUN:
			anim_player.play("running")
		PLAYER_STATES.IDLE:
			anim_player.play("idle")
		PLAYER_STATES.FALL:
			anim_player.play("fall")
		PLAYER_STATES.JUMP:
			anim_player.play("jumping")
			if !is_playing_sound:
				is_playing_sound = true
				SoundManager.play_clip(audio_player, SoundManager.SOUND_JUMP)
		PLAYER_STATES.SHOOT:
			anim_player.play("attack")
			if !is_playing_sound:
				is_playing_sound = true
				SoundManager.play_clip(audio_player, SoundManager.SOUND_ATTACK)
		PLAYER_STATES.RUNSHOOT:
			anim_player.play("run_attack")
			if !is_playing_sound:
				is_playing_sound = true
				SoundManager.play_clip(audio_player, SoundManager.SOUND_ATTACK)
		PLAYER_STATES.HURT:
			anim_player.play("hurt")
			if !is_playing_sound:
				is_playing_sound = true
				SoundManager.play_clip(audio_player, SoundManager.SOUND_HURT)
		PLAYER_STATES.DEATH:
			anim_player.play("death")
			if !is_playing_sound:
				is_playing_sound = true
				SoundManager.play_clip(audio_player, SoundManager.SOUND_DEATH)

func get_input():
	velocity.x = 0
	if not is_invicible:
		var current_speed = MOVEMENT_SPEED
		
		if !on_shoot and Input.is_action_pressed("run"):
			current_speed = BOOSTED_SPEED
			
		if(Input.is_action_pressed("movement_left")):
			sprite2d.flip_h = true 
			velocity.x = -current_speed
		elif(Input.is_action_pressed("movement_right")):
			sprite2d.flip_h = false 
			velocity.x = current_speed
			
		if Input.is_action_just_pressed("jump"):
			if is_on_floor():
				velocity.y = -JUMP_FORCE
		
		if !on_shoot and Input.is_action_just_pressed("attack"):
			if is_on_floor():
				on_shoot = true
				animationShoot_timer.start()
				shoot_timer.start()

func apply_gravity(delta: float):
	velocity.y += GRAVITY * delta	
	
func  shootFire():
	var shoot_fire = fire.instantiate()
	if sprite2d.flip_h:
		shoot_marker.scale.x = -1
		shoot_fire.global_position = sprite2d.global_position + Vector2(-20, 0)
		shoot_fire.velocity = -VELOCITY_SHOOT
	else:
		shoot_marker.scale.x = 1
		shoot_fire.global_position = sprite2d.global_position + Vector2(20, 0)
		shoot_fire.velocity = VELOCITY_SHOOT
	shoot_fire.global_position = $Shoot/Direction.global_position
	var mundo_node = get_tree().root.get_node("LevelTest")
	if mundo_node:
		mundo_node.add_child(shoot_fire)
	else:
		print("Error: Nodo 'Mundo' no encontrado.")

func _on_animation_shoot_timer_timeout():
	on_shoot = false
	shoot_count = 0

func _on_shoot_timer_timeout():
	if on_shoot and shoot_count == 0:
		shoot_count += 1
		shootFire()

func _on_hit_box_area_entered(area):
	if not is_invicible:
		appy_hit()

func appy_hit():
	SignalManager.on_damage.emit()
	print("Me ha dañado un alien")
	is_invicible = true
	invicible_timer.start()
	if sprite2d.flip_h:
		velocity.x = -HURT_JUMP_FORCE * 10
	else:
		velocity.x = HURT_JUMP_FORCE * 10
	velocity.y = HURT_JUMP_FORCE
	move_and_slide()

func _on_invincible_timer_timeout():
	is_invicible = false

func on_death():
	is_death = true

func _on_animation_player_animation_finished(anim_name):
	if is_death:
		SignalManager.on_game_over.emit()
		stop = true


func _on_audio_stream_player_2d_finished():
	is_playing_sound = false
