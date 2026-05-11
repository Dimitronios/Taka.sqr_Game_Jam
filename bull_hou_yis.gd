extends Area2D

var damage: float = 1.0
var travelled_distance = 0.0
var charge: float = 0.0

func _ready():
	# Μέγεθος βέλους ανάλογα με charge
	var scale_amount = 0.3 + (charge * 0.7)
	$houbullet.scale = Vector2(scale_amount, scale_amount)

func _physics_process(delta):
	var speed = 400 + (charge * 800)
	var range = 250 + (charge * 600)
	damage = 1.0 + (charge * 2.0)
	
	position += Vector2.RIGHT.rotated(rotation) * speed * delta
	travelled_distance += speed * delta
	if travelled_distance > range:
		queue_free()

func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)
	
	
