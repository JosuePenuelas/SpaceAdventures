extends StaticBody2D

@export var num_character: int = 0
@onready var player_sprite = $PlayerAnimatedSprite
@onready var alien1_sprite = $Alien1AnimatedSprite
@onready var timer = $Timer
var velocity: int

func _ready():
	if num_character == 0:
		player_sprite.show()
		player_sprite.play()
		timer.start()
	elif num_character == 1:
		alien1_sprite.show()
		alien1_sprite.play()
		timer.start()
	self.set_collision_layer(0)
	self.set_collision_mask(0)

func _process(delta):
	global_position.x += delta * velocity

func _on_visible_on_screen_enabler_2d_screen_exited():
	queue_free()

func _on_area_2d_area_entered(area):
	queue_free()

func _on_timer_timeout():
	queue_free()
