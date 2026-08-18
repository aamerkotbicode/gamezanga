extends Node2D

var speed = 100.0
var ground_width = 1919.0

var ground_scene = preload("res://SCENES/menus/ground.tscn")

var current_ground
var next_ground


func _ready() -> void:
	$AnimatedSprite2D.play("run")
	$AnimationPlayer.play("titledown")
	current_ground = ground_scene.instantiate()
	current_ground.position = Vector2(0, 200)
	add_child(current_ground)
	await $AnimationPlayer.animation_finished
	desc()
	


func _process(delta: float) -> void:

	if is_instance_valid(current_ground):
		current_ground.position.x -= speed * delta

		if current_ground.position.x <= 0 and not is_instance_valid(next_ground):
			next_ground = ground_scene.instantiate()

			next_ground.position.x = current_ground.position.x + ground_width
			next_ground.position.y = current_ground.position.y

			add_child(next_ground)

	if is_instance_valid(next_ground):
		next_ground.position.x -= speed * delta

	if is_instance_valid(current_ground):
		if current_ground.position.x <= -ground_width:
			current_ground.queue_free()
			current_ground = next_ground
			next_ground = null
func desc():
	$descanimation.play("desc")
