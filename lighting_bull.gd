extends Area2D

var damage: float = 1.5
var travelled_distance = 0

func _ready():
	body_entered.connect(_on_body_entered)  # Σύνδεση signal
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
	if body.is_in_group("player"):  # Αγνοεί τον player
		return
	if body.has_method("take_damage"):
		body.take_damage(damage)
	queue_free()  # queue_free ΜΕΤΑ το take_damage
