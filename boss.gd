extends CharacterBody2D

@export var default_sprite: Texture2D
@export var homing_sprite: Texture2D
@export var nova_sprite: Texture2D

var max_health: int = 2000
var current_health: int = 2000

var current_phase: int = 1
var nova_fired_this_phase: bool = false

var base_speed: float = 100.0
var is_attacking: bool = false

@onready var player = get_node("/root/BossLevel/Player")

func _ready():
	current_health = max_health
	$Sprite2D.texture = default_sprite
	
	await get_tree().create_timer(2.0).timeout
	trigger_stinger_combo()

func _physics_process(delta):
	if is_attacking == false and player != null:
		var direction = global_position.direction_to(player.global_position)
		velocity = direction * base_speed
		move_and_slide()

func trigger_stinger_combo():
	is_attacking = true
	$Sprite2D.texture = homing_sprite 
	
	var dash_speed = player.speed * 0.70 
	
	for i in range(3):
		var target_position = player.global_position
		var distance = global_position.distance_to(target_position)
		var dash_time = distance / dash_speed
		
		var tween = create_tween()
		tween.tween_property(self, "global_position", target_position, dash_time).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
		
		await tween.finished
		await get_tree().create_timer(0.3).timeout

	$Sprite2D.texture = default_sprite
	is_attacking = false

func take_damage(amount: int):
	current_health -= amount
	var hp_percent = float(current_health) / float(max_health)
	check_phase_triggers(hp_percent)
	if current_health <= 0:
		die()

func check_phase_triggers(hp_percent: float):
	if current_phase == 1:
		if hp_percent <= 0.87 and not nova_fired_this_phase:
			fire_nova(1) 
			nova_fired_this_phase = true
		if hp_percent <= 0.75:
			trigger_stinger_combo() 
			current_phase = 2
			nova_fired_this_phase = false 

	elif current_phase == 2:
		if hp_percent <= 0.62 and not nova_fired_this_phase:
			fire_nova(2) 
			nova_fired_this_phase = true
		if hp_percent <= 0.50:
			trigger_stinger_combo()
			current_phase = 3
			nova_fired_this_phase = false

	elif current_phase == 3:
		if hp_percent <= 0.37 and not nova_fired_this_phase:
			fire_nova(3) 
			nova_fired_this_phase = true
		if hp_percent <= 0.25:
			trigger_stinger_combo()
			current_phase = 4
			nova_fired_this_phase = false
			
	elif current_phase == 4:
		if hp_percent <= 0.12 and not nova_fired_this_phase:
			fire_nova(4) 
			nova_fired_this_phase = true

func fire_nova(wave_count: int):
	pass

func die():
	queue_free()
