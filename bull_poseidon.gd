extends Area2D

var damage: float = 2.0
var travelled_distance = 0
var returning = false

func _physics_process(delta):
	const SPEED = 700
	const RANGE = 500
	var player = get_tree().get_first_node_in_group("player")
	
	if not returning:
		position += Vector2.RIGHT.rotated(rotation) * SPEED * delta
		travelled_distance += SPEED * delta
		if travelled_distance > RANGE:
			returning = true
	
func shoot_water():
	const WATER = preload("res://water_bull.tscn")
	for angle in [-120, 0, 120]:
		var drop = WATER.instantiate()
		drop.global_position = global_position
		drop.rotation_degrees = rotation_degrees + angle
		get_tree().root.add_child(drop)

func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)
		queue_free()
	shoot_water()
	
	
