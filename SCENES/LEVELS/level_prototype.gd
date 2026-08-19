extends Node2D
@onready var sppos = $spawn_position#kashira!
var spawn_position : Vector2
func _ready() -> void:
	spawn_position = sppos.position

func _on_player_respawned():
	for entity in $Collectables.get_children():
		entity.reset()
