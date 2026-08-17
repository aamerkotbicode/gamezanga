extends Node2D
@onready var sppos = $spawn_position#kashira!
var spawn_position : Vector2
func _ready() -> void:
	spawn_position = sppos.position
