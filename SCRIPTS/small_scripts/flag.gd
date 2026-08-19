extends Area2D
signal checkpoint(newflagpos)

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		horray()
		checkpoint.emit(position)
func horray():
	$Sprite2D.visible = false
	$Sprite2D2.visible = true
	$GPUParticles2D.emitting = true

func reset():
	pass
