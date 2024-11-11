extends CharacterBody2D

@export var fire: PackedScene

@onready var anim_enemy = $AnimationPlayer
@onready var sprite2d = $Sprite2D
@onready var audio_player = $AudioStreamPlayer2D
@onready var death_sprite = $DeathSprite
@onready var attack_sprite = $AttackSprite
@onready var floor_detection = $FloorDetection
@onready var wall_detection = $WallDetection
@onready var invicible_timer = $InvincibleTimer
@onready var shoot_marker = $Shoot
@onready var shoot_timer = $ShootTimer
@onready var animationShoot_timer = $AnimationShootTimer

var rng = RandomNumberGenerator.new()

const GRAVITY: float = 1000.0
const MOVEMENT_SPEED: float = 60.0
const VELOCITY_SHOOT: float = 320.0

var lives: int = 3
var shoot_count: int = 0

var on_shoot: bool = false
var is_invicible: bool = false
var is_death: bool = false
var is_playing_sound : bool = false

enum FACING_DRECTION {LEFT = -1, RIGHT = 1}
var current_direction = FACING_DRECTION.RIGHT

enum ENEMY_STATES {IDLE, RUN, FALL, JUMP, HURT, ATTACK, DEATH}
var current_state: ENEMY_STATES = ENEMY_STATES.IDLE

func _ready():
	SignalManager.on_pause.connect(on_pause)
	
func on_pause():
	audio_player.stop()

func calculate_state():
	if is_death:
		set_state(ENEMY_STATES.DEATH)
		return
		
	if is_invicible:
		set_state(ENEMY_STATES.HURT)
	else:
		if is_on_floor():
			if velocity.x != 0 and not on_shoot:
				set_state(ENEMY_STATES.RUN)
			else:
				if on_shoot:
					set_state(ENEMY_STATES.ATTACK)
				else:
					set_state(ENEMY_STATES.IDLE)

func set_state(new_state: ENEMY_STATES):
	current_state = new_state
	match current_state:
		ENEMY_STATES.RUN:
			sprite2d.visible = true
			attack_sprite.visible = false
			death_sprite.visible = false
			anim_enemy.play("running")
		ENEMY_STATES.IDLE:
			sprite2d.visible = true
			attack_sprite.visible = false
			death_sprite.visible = false
			anim_enemy.play("idle")
		ENEMY_STATES.HURT:
			velocity.x = 0
			sprite2d.visible = true
			attack_sprite.visible = false
			death_sprite.visible = false
			anim_enemy.play("hurt")
			if !is_playing_sound:
				is_playing_sound = true
				SoundManager.play_clip(audio_player, SoundManager.SOUNDS_ENEMY_HURT)
		ENEMY_STATES.ATTACK:
			velocity.x = 0
			attack_sprite.visible = true
			sprite2d.visible = false
			death_sprite.visible = false
			attack_sprite.play()
			if !is_playing_sound:
				is_playing_sound = true
				SoundManager.play_clip(audio_player, SoundManager.SOUNDS_ENEMY_ATTACK)
		ENEMY_STATES.DEATH:
			velocity.x = 0
			death_sprite.visible = true
			sprite2d.visible = false
			attack_sprite.visible = false
			death_sprite.play()
			if !is_playing_sound:
				is_playing_sound = true
				SoundManager.play_clip(audio_player, SoundManager.SOUNDS_ENEMY_DEATH)

func _physics_process(delta):
	if not is_on_floor():
		apply_gravity(delta)
	
	# Solo iniciar movimiento si no está disparando
	if not on_shoot:
		var random_int = rng.randf_range(0, 3)
		if random_int > 2.98:
			on_shoot = true
			animationShoot_timer.start()
			shoot_timer.start()
		else:
			alien_move()

	calculate_state()
	move_and_slide()

func alien_move():
	if wall_detection.is_colliding() or not floor_detection.is_colliding() and is_on_floor():
		flip_me()
	velocity.x = MOVEMENT_SPEED * current_direction

func alien_attack():
	var shoot_fire = fire.instantiate()
	shoot_fire.num_character = 1
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

func flip_me():
	if current_direction == FACING_DRECTION.LEFT:
		current_direction = FACING_DRECTION.RIGHT
		sprite2d.flip_h = false
		attack_sprite.flip_h = false
	else:
		current_direction = FACING_DRECTION.LEFT
		sprite2d.flip_h = true
		attack_sprite.flip_h = true
	floor_detection.position.x *= -1
	wall_detection.target_position.x *= -1

func apply_gravity(delta: float):
	velocity.y += GRAVITY * delta

func _on_hit_box_area_entered(area):
	lives -= 1
	print("Me han disparado")
	if lives == 0:
		print("Alien muerto")
		is_death =  true
	invicible_timer.start()
	is_invicible = true

func _on_invincible_timer_timeout():
	is_invicible = false

func _on_death_sprite_animation_finished():
	if is_death:
		queue_free()

func _on_animation_shoot_timer_timeout():
	pass

func _on_shoot_timer_timeout():
	if on_shoot and shoot_count == 0:
		shoot_count += 1
		alien_attack()

func _on_attack_sprite_animation_finished():
	on_shoot = false
	shoot_count = 0

func _on_audio_stream_player_2d_finished():
	is_playing_sound = false
