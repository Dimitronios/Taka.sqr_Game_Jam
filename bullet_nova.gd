extends Area2D

var speed: float = 1000 
var damage: int = 4

func _physics_process(delta):
	position += transform.x * speed * delta

	
func _on_body_entered(body):
	if body.name == "Player":
		body.current_health -= damage
		
	if body.get_node_or_null("%HealthBar"):
		body.get_node("%HealthBar").value = body.current_health
			
	if body.current_health <= 0:
		body.health_depleted.emit()
			
	queue_free()
