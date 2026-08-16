extends CharacterBody2D

const SPEED = 700.0
const JUMP_VELOCITY = -1600.0

@onready var sprite = $AnimatedSprite2D

var normal_scale = Vector2(9, 9)
var squash_scale = Vector2(9, 8.8)


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

	# Movement
	var direction = Input.get_axis("ui_left", "ui_right")

	if direction:
		velocity.x = direction * SPEED
		
		# Flip sprite
		sprite.flip_h = direction > 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Animations
	if velocity.x == 0 and is_on_floor():
		sprite.play("idle")

	if velocity.x != 0 and is_on_floor():
		sprite.play("run")

	move_and_slide()
	
