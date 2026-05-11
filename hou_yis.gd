extends Area2D

@onready var player = get_parent().get_parent()
@onready var sprite = $WeaponPivot/houbow

var charge_time = 0.0
var is_charging = false
var can_shoot = true
const MAX_CHARGE = 2.0
const COOLDOWN = 1

func _process(delta):
	look_at(get_global_mouse_position())
	
	if is_charging:
		charge_time += delta
		charge_time = min(charge_time, MAX_CHARGE)
		sprite.scale = Vector2(1.5 + charge_time * 0.5, 1.5 + charge_time * 0.5)

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and can_shoot and not is_charging:
			is_charging = true
			charge_time = 0.0
		elif not event.pressed and is_charging:
			is_charging = false
			can_shoot = false
			shoot()
			sprite.scale = Vector2(1.0, 1.0)
			await get_tree().create_timer(COOLDOWN).timeout
			can_shoot = true

func shoot():
	const BULLET = preload("res://bull_hou_yis.tscn")
	var new_bullet = BULLET.instantiate()
	new_bullet.global_transform = %ShootingPoint.global_transform
	new_bullet.charge = charge_time
	get_tree().root.add_child(new_bullet)
