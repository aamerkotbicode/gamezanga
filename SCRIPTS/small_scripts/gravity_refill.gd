extends Area2D
@onready var particle = $GPUParticles2D
func _ready() -> void:
	$Hover.play("hover_up")
func _on_body_entered(body: Node2D) -> void:
	print("body_entered")
	if body.name == "Player":
		print("his name is player")
		body.Refill()
		$Sprite2D.visible = false
		$CollisionShape2D.disabled = true
		particle.emitting = true

func _process(_delta: float) -> void:
	$Sprite2D.position = $CollisionShape2D.position + Vector2(0, 3)
	particle.position = $CollisionShape2D.position + Vector2(0, 3)
func _on_hover_animation_finished(anim_name: StringName) -> void:
	if anim_name == "hover_up":
		$Hover.play("hover_up")


func reset():
	$Sprite2D.visible = true
	$CollisionShape2D.disabled = false
