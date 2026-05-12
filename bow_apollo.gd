extends Area2D

@onready var player = get_parent().get_parent()

func _process(delta):
	look_at(get_global_mouse_position())

func shoot():
	const BULLET = preload("res://bull_apollo.tscn")
	for i in range(4):
		var new_bullet = BULLET.instantiate()
		new_bullet.global_position = %ShootingPoint.global_position
		new_bullet.rotation_degrees = i * 90
		get_tree().root.add_child(new_bullet)

func _on_timer_timeout() -> void:
	shoot()
