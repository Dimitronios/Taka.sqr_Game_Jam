extends Area2D

var damage: int = 2
const SPEED = 650

func _physics_process(delta):
	position += Vector2.RIGHT.rotated(rotation) * SPEED * delta

func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)
	queue_free()
