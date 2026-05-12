extends Area2D

@onready var player = get_parent().get_parent()


func _process(_delta):
	
	look_at(get_global_mouse_position())

func shoot():
	const BULLET = preload("res://bull_gugnir.tscn")
	var new_bullet = BULLET.instantiate()
	new_bullet.global_transform = %ShootingPoint.global_transform
	#new_bullet.damage = player.strength
	get_tree().root.add_child(new_bullet)

func _on_timer_timeout() -> void:
	
	shoot()

@export var bullet_scene: PackedScene
