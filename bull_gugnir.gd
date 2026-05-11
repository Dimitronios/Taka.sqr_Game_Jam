extends Area2D

var damage: float = 2.0
var target = null
const SPEED = 700

func _ready():
	find_target()

func find_target():
	var enemies = get_tree().get_nodes_in_group("enemies")
	if enemies.is_empty():
		queue_free()
		return
	
	# Βρες τον πιο κοντινό εχθρό
	var closest = null
	var closest_dist = INF
	for enemy in enemies:
		var dist = global_position.distance_to(enemy.global_position)
		if dist < closest_dist:
			closest_dist = dist
			closest = enemy
	
	target = closest

func _physics_process(delta):
	# Αν ο target πέθανε βρες νέο
	if not is_instance_valid(target):
		find_target()
		return
	
	# Ακολουθεί τον εχθρό
	var direction = (target.global_position - global_position).normalized()
	global_position += direction * SPEED * delta
	rotation = direction.angle()

func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)
		queue_free()
