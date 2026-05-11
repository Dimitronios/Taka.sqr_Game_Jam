extends Area2D


var damage: float = 1
var travelled_distance = 0

func _ready():
	$CollisionShape2D.disabled = true
	await get_tree().create_timer(0.15).timeout
	$CollisionShape2D.disabled = false


func _physics_process(delta):
	const SPEED = 620
	const RANGE = 250
	position += Vector2.RIGHT.rotated(rotation) * SPEED * delta
	travelled_distance += SPEED * delta
	if travelled_distance > RANGE:
		queue_free()

func _on_body_entered(body):
	
	if body.has_method("take_damage"):
		body.take_damage(damage)
