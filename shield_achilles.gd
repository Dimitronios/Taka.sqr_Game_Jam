extends Area2D

var damage: float = 3
const SPEED = 1.5
var can_damage = true

func _process(delta):
	
	global_position = global_position.lerp(get_global_mouse_position(), SPEED * delta)
	rotation = (get_global_mouse_position() - global_position).angle()

func _on_body_entered(body):
	if body.has_method("take_damage") and can_damage:
		body.take_damage(damage)
		can_damage = false
		await get_tree().create_timer(0.2).timeout
		can_damage = true
