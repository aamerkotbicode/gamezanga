extends CharacterBody2D

var speed = 700.0

const JUMP_VELOCITY = -1600.0
const WALL_JUMP_VELOCITY = -1400.0
const WALL_JUMP_HOR_SPEED = 1800.0

@onready var sprite = $AnimatedSprite2D
@onready var ray_cast_left = $RayCast2Dleft
@onready var ray_cast_right = $RayCast2Dright
@onready var particles = $GPUParticles2D

var normal_scale = Vector2(9, 9)
var squash_scale = Vector2(9, 8.8)
var wall_jump_used_vel = WALL_JUMP_VELOCITY
var im_trying_to_walljump_man = false
var is_flipped = false
var dead = false

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept") and dead:
		Respawn()

func _physics_process(delta):

	if Input.is_action_just_pressed("SHIFT") and not is_on_floor() and not is_on_ceiling():
		is_flipped = !is_flipped

	if is_on_floor() and is_flipped:
		is_flipped = false

	sprite.flip_v = is_flipped

	if is_flipped:
		wall_jump_used_vel = -WALL_JUMP_VELOCITY
	else:
		wall_jump_used_vel = WALL_JUMP_VELOCITY

	var gravity = get_gravity()

	if is_flipped:
		gravity = -gravity

		if not is_on_ceiling():
			velocity += gravity * 2 * delta
			sprite.play("jump")
	else:
		if not is_on_floor():
			velocity += gravity * 2 * delta
			sprite.play("jump")

	if Input.is_action_just_pressed("ui_accept") and (is_on_floor() or is_on_ceiling()):
		sprite.scale.y = squash_scale.y

		if is_flipped:
			velocity.y = -JUMP_VELOCITY
		else:
			velocity.y = JUMP_VELOCITY

	if Input.is_action_just_released("ui_accept"):

		if not is_flipped and velocity.y < 0:
			velocity.y = JUMP_VELOCITY / 4

		elif is_flipped and velocity.y > 0:
			velocity.y = -JUMP_VELOCITY / 4

	if Input.is_action_just_pressed("ui_accept") \
	and not is_on_floor() \
	and not is_on_ceiling():

		if ray_cast_left.is_colliding():
			im_trying_to_walljump_man = true
			velocity.x = WALL_JUMP_HOR_SPEED
			velocity.y = wall_jump_used_vel
			sprite.flip_h = false
			sprite.scale.y = squash_scale.y

		elif ray_cast_right.is_colliding():
			im_trying_to_walljump_man = true
			velocity.x = -WALL_JUMP_HOR_SPEED
			velocity.y = wall_jump_used_vel
			sprite.flip_h = true
			sprite.scale.y = squash_scale.y

	if Input.is_action_pressed("ui_down"):
		speed = 800.0
	else:
		speed = 700.0

	var direction = Input.get_axis("ui_left", "ui_right")

	if direction and not im_trying_to_walljump_man:
		velocity.x = direction * speed
		sprite.flip_h = direction > 0

	elif not im_trying_to_walljump_man:
		velocity.x = move_toward(velocity.x, 0, speed)

	if velocity.x == 0 and (is_on_floor() or is_on_ceiling()):
		sprite.play("idle")

	elif velocity.x != 0 and (is_on_floor() or is_on_ceiling()):

		if is_flipped:
			sprite.play("upward_sneak")
		else:
			sprite.play("run")

	if im_trying_to_walljump_man:
		im_trying_to_walljump_man = false

	move_and_slide()

func die():
	set_physics_process(false)
	is_flipped = false
	sprite.flip_v = false
	death_animation()
	dead = true


func death_animation():
	particles.emitting = true
	sprite.visible = false


func Respawn():
	position = get_parent().spawn_position
	sprite.visible = true
	set_physics_process(true)
	dead = false
