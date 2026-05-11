extends Area2D

var damage: int = 1
var travelled_distance = 0
var returning = false

func _physics_process(delta):
	const SPEED = 950
	const RANGE = 600
	var player = get_tree().get_first_node_in_group("player")
	print(player)
	
	if not returning:
		position += Vector2.RIGHT.rotated(rotation) * SPEED * delta
		travelled_distance += SPEED * delta
		if travelled_distance > RANGE:
			returning = true
	else:
		global_position = global_position.move_toward(player.global_position, SPEED * delta)
		if global_position.distance_to(player.global_position) < 10:
			shoot_lightning()
			queue_free()

func shoot_lightning():
	const LIGHTNING = preload("res://lighting_bull.tscn")
	for angle in range(0, 360, 45):
		var bolt = LIGHTNING.instantiate()
		bolt.global_position = global_position
		bolt.rotation_degrees = angle
		get_tree().root.add_child(bolt)

func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)
