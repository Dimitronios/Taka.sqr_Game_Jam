extends CharacterBody2D

signal health_changed(current_hp, max_hp)


const GRAPE_BULLET = preload("res://grape_bullet.tscn")
const NOVA_BULLET = preload("res://nova_bullet.tscn")
const VICTORY_SCREEN = preload("res://victory_screen.tscn") 

@export_group("Visuals")
@export var default_sprite: Texture2D
@export var homing_sprite: Texture2D
@export var nova_sprite: Texture2D

@export_group("Stats")
@export var max_health: int = 300 
@onready var current_health: int = max_health
@export var stinger_pause: float = 1.0 

var current_phase: int = 1
var nova_stage: int = 0 
var homing_triggered_75: bool = false
var homing_triggered_50: bool = false
var homing_triggered_25: bool = false

var base_speed: float = 120.0 
var is_attacking: bool = false

@onready var player = get_node("/root/BossLevel/Player")
@onready var shooting_point = $ShootingPoint
@onready var dash_hitbox = $DashHitbox 

func _ready():
	current_health = max_health
	$Sprite2D.texture = default_sprite
	dash_hitbox.monitoring = false 
	
	await get_tree().process_frame
	health_changed.emit(current_health, max_health)
	
	await get_tree().create_timer(2.0).timeout
	trigger_stinger_combo()

func _physics_process(delta):
	if player != null:
		shooting_point.look_at(player.global_position)
		if not is_attacking:
			var direction = global_position.direction_to(player.global_position)
			velocity = direction * base_speed
			move_and_slide()

func shoot_grape():
	if player == null or is_attacking:
		return
	var new_grape = GRAPE_BULLET.instantiate()
	new_grape.global_position = shooting_point.global_position
	new_grape.rotation = shooting_point.rotation
	if "damage" in new_grape:
		new_grape.damage = 1
	get_tree().root.add_child(new_grape)

func _on_basic_attack_timer_timeout():
	shoot_grape()

func trigger_stinger_combo():
	is_attacking = true
	$Sprite2D.texture = homing_sprite 
	dash_hitbox.monitoring = true 
	
	var dash_speed = 1750 * 0.45 
	
	for i in range(1): 
		if player == null: break
		var target_position = player.global_position
		var distance = global_position.distance_to(target_position)
		var dash_time = distance / dash_speed
		
		var tween = create_tween()
		tween.tween_property(self, "global_position", target_position, dash_time).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
		
		await tween.finished
		await get_tree().create_timer(stinger_pause).timeout 

	$Sprite2D.texture = default_sprite
	dash_hitbox.monitoring = false 
	is_attacking = false

func take_damage(amount: int):
	current_health -= amount
	health_changed.emit(current_health, max_health) 
	var hp_percent = (float(current_health) / max_health) * 100.0
	check_triggers(hp_percent)
	if current_health <= 0:
		die()

func check_triggers(hp_percent: float):
	if hp_percent <= 75.0 and not homing_triggered_75:
		trigger_stinger_combo(); homing_triggered_75 = true
	elif hp_percent <= 50.0 and not homing_triggered_50:
		trigger_stinger_combo(); homing_triggered_50 = true
	elif hp_percent <= 25.0 and not homing_triggered_25:
		trigger_stinger_combo(); homing_triggered_25 = true

	if hp_percent <= 100.0 and hp_percent > 75.0 and nova_stage == 0:
		fire_nova(1); nova_stage = 1
	elif hp_percent <= 75.0 and hp_percent > 50.0 and nova_stage == 1:
		fire_nova(2); nova_stage = 2
	elif hp_percent <= 50.0 and hp_percent > 25.0 and nova_stage == 2:
		fire_nova(3); nova_stage = 3
	elif hp_percent <= 25.0 and hp_percent > 0.0 and nova_stage == 3:
		fire_nova(4); nova_stage = 4

func fire_nova(wave_count: int):
	is_attacking = true
	$Sprite2D.texture = nova_sprite
	for round_num in range(wave_count):
		for i in range(10):
			var bullet = NOVA_BULLET.instantiate()
			bullet.global_position = shooting_point.global_position
			bullet.rotation = i * (TAU / 10.0) 
			
			if "damage" in bullet: bullet.damage = 4 
			if "speed" in bullet: bullet.speed = 1750
			get_tree().root.add_child(bullet)
		if wave_count > 1:
			await get_tree().create_timer(0.5).timeout
	$Sprite2D.texture = default_sprite
	is_attacking = false

func die():
	get_tree().paused = true
	
	var victory = VICTORY_SCREEN.instantiate()
	get_tree().root.add_child(victory)
	
	queue_free()

func _on_dash_hitbox_body_entered(body):
	if body.is_in_group("player") and body.has_method("take_damage"):
		body.take_damage(4)
