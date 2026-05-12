extends Area2D

var damage: int = 1
var travelled_distance = 0

func _ready():
	body_entered.connect(_on_body_entered)  # 👈 αυτό έλειπε

func _physics_process(delta):
	const SPEED = 1750
	const RANGE = 1200

	position += Vector2.RIGHT.rotated(rotation) * SPEED * delta
	travelled_distance += SPEED * delta
	if travelled_distance > RANGE:
		queue_free()

func _on_body_entered(body):
	if body.is_in_group("player"):
		if body.has_method("take_damage"):
			body.take_damage(damage)
		queue_free()
	elif body.is_in_group("enemy"):
		return
	else:
		queue_free()
