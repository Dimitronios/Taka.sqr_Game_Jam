extends Area2D
@onready var player = get_parent().get_parent()
func _process(_delta):
	look_at(get_global_mouse_position())
func shoot():
	const BULLET = preload("res://bull_pashupatastra.tscn")
	for angle in range(0, 360, 45):
		var new_bullet = BULLET.instantiate()
		new_bullet.global_position = %ShootingPoint.global_position
		new_bullet.rotation_degrees = angle
		get_tree().root.add_child(new_bullet)
func _on_timer_timeout() -> void:
	shoot()
@export var bullet_scene: PackedScene
