extends CharacterBody2D

var speed = 700.0
const JUMP_VELOCITY = -1600.0
const WALL_JUMP_VELOCITY = Vector2(1200.0, -1400.0)
@onready var sprite = $AnimatedSprite2D

var normal_scale = Vector2(9, 9)
var squash_scale = Vector2(9, 8.8)
var im_trying_to_walljump_man = false

@onready var ray_cast_left = $RayCast2Dleft
@onready var ray_cast_right = $RayCast2Dright
func _physics_process(delta):

	# Smoothly return to normal height
	sprite.scale.y = lerp(sprite.scale.y, normal_scale.y, 10.0 * delta)

	if not is_on_floor():
		velocity += get_gravity() * 2 * delta
		sprite.play("jump")

	# Jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		sprite.scale.y = squash_scale.y
		velocity.y = JUMP_VELOCITY

	if Input.is_action_just_released("ui_accept") and velocity.y < 0:
		velocity.y = JUMP_VELOCITY / 4

	if Input.is_action_just_pressed("ui_accept") and not is_on_floor():
		if ray_cast_left.is_colliding():
			im_trying_to_walljump_man = true
			velocity.x = 500.0
			velocity.y = WALL_JUMP_VELOCITY.y
			sprite.flip_h = false
			sprite.scale.y = squash_scale.y
			im_trying_to_walljump_man = false

		elif ray_cast_right.is_colliding():
			im_trying_to_walljump_man = true
			velocity.x = -500.0
			velocity.y = WALL_JUMP_VELOCITY.y
			sprite.flip_h = true
			sprite.scale.y = squash_scale.y
			im_trying_to_walljump_man = false

	if Input.is_action_pressed("ui_down"):
		speed = 800
	else:
		speed = 700
	var direction = Input.get_axis("ui_left", "ui_right")

	if direction and !im_trying_to_walljump_man:
		velocity.x = direction * speed
		
		# Flip sprite
		sprite.flip_h = direction > 0
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	# Animations
	if velocity.x == 0 and is_on_floor():
		sprite.play("idle")

	if velocity.x != 0 and is_on_floor():
		sprite.play("run")

	move_and_slide()
	
