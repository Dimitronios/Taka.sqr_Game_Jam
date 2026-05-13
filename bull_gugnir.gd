extends Area2D

var damage: float = 2
var target = null
const SPEED = 800

func _ready():
	body_entered.connect(_on_body_entered)  # Σύνδεση signal
	find_target()

func find_target():
	var enemies = get_tree().get_nodes_in_group("enemies")
	if enemies.is_empty():
		queue_free()
		return

	var closest = null
	var closest_dist = INF
	for enemy in enemies:
		var dist = global_position.distance_to(enemy.global_position)
		if dist < closest_dist:
			closest_dist = dist
			closest = enemy

	target = closest

func _physics_process(delta):
	if not is_instance_valid(target):
		find_target()
		return

	var direction = (target.global_position - global_position).normalized()
	global_position += direction * SPEED * delta
	rotation = direction.angle()

func _on_body_entered(body):
	if body.is_in_group("player"):  # 👈 Αγνοεί τον player
		return
	if body.has_method("take_damage"):
		body.take_damage(damage)
	queue_free()
