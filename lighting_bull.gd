extends Area2D


var damage: float = 1.5
var travelled_distance = 0

func _ready():
	$CollisionShape2D.disabled = true
	await get_tree().create_timer(0.1).timeout
	$CollisionShape2D.disabled = false

func _physics_process(delta):
	const SPEED = 1400
	const RANGE = 500
	position += Vector2.RIGHT.rotated(rotation) * SPEED * delta
	travelled_distance += SPEED * delta
	if travelled_distance > RANGE:
		queue_free()

func _on_body_entered(body):
	queue_free()
	if body.has_method("take_damage"):
		body.take_damage(damage)
	
