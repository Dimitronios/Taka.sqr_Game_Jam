extends Area2D

var damage: int = 1
var travelled_distance = 0

func _physics_process(delta):
	const SPEED = 1750 # Lowered from 1000 so it's slower than the player's bullet
	const RANGE = 1200

	# Moves forward based on its current rotation
	position += Vector2.RIGHT.rotated(rotation) * SPEED * delta
	
	travelled_distance += SPEED * delta
	if travelled_distance > RANGE:
		queue_free()

func _on_body_entered(body):
	# Make sure it only damages the player
	if body.is_in_group("player") and body.has_method("take_damage"):
		body.take_damage(damage)
	queue_free()
