extends AnimatableBody2D
@onready var right = $right
@onready var left = $left
var dir = 1

func _physics_process(_delta: float) -> void:
	position.x += 5 * dir
	if right.is_colliding():
		dir = -1
	if left.is_colliding():
		dir = 1
