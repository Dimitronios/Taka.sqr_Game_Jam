extends Area2D


@onready var player = get_parent()

func _process(_delta):
	look_at(get_global_mouse_position())

func shoot():
	const BULLET = preload("res://bullet_2d.tscn")
	var new_bullet = BULLET.instantiate()
	new_bullet.global_transform = %ShootingPoint.global_transform
	
   
	new_bullet.damage = player.strength 
	
	%ShootingPoint.add_child(new_bullet)

func _on_timer_timeout() -> void:
	shoot()
