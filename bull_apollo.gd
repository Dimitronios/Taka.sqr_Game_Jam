extends Area2D

var damage: float = 1.0
var target = null
var can_seek = false
const SPEED = 800


	

func _ready():
	$CollisionShape2D.disabled = true
	await get_tree().create_timer(0.1).timeout
	$CollisionShape2D.disabled = false
	$CollisionShape2D.disabled = true
	await get_tree().create_timer(0.1).timeout
	$CollisionShape2D.disabled = false
	await get_tree().create_timer(0.2).timeout
	find_target()
	can_seek = true

func find_target():
	var enemies = get_tree().get_nodes_in_group("enemies")
	if enemies.is_empty():
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
	if not can_seek:
		global_position += Vector2.RIGHT.rotated(rotation) * SPEED * delta
		return
	
	if not is_instance_valid(target):
		find_target()
		if not is_instance_valid(target):
			queue_free()
			return
	
	var direction = (target.global_position - global_position).normalized()
	global_position += direction * SPEED * delta
	rotation = direction.angle()

func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)
	queue_free()
