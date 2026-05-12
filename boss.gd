extends CharacterBody2D

# --- PRELOAD BULLETS ---
const GRAPE_BULLET = preload("res://grape_bullet.tscn")
const NOVA_BULLET = preload("res://nova_bullet.tscn")

@export var default_sprite: Texture2D
@export var homing_sprite: Texture2D
@export var nova_sprite: Texture2D

var max_health: int = 1000
var current_health: int = 1000

var current_phase: int = 1
var nova_fired_this_phase: bool = false

var base_speed: float = 100.0
var is_attacking: bool = false

# --- NODES ---
@onready var player = get_node("/root/BossLevel/Player")
@onready var shooting_point = $ShootingPoint

func _ready():
	current_health = max_health
	$Sprite2D.texture = default_sprite
	
	await get_tree().create_timer(2.0).timeout
	trigger_stinger_combo()

func _physics_process(delta):
	if player != null:
		# Always make the shooting point aim at the player for basic attacks
		shooting_point.look_at(player.global_position)
		
		# Only walk toward the player if he isn't dashing or casting the Nova
		if is_attacking == false:
			var direction = global_position.direction_to(player.global_position)
			velocity = direction * base_speed
			move_and_slide()

# --- BASIC ATTACK LOGIC ---
func shoot_grape():
	# Don't shoot basic grapes while he is doing a big attack (stinger or nova)
	if player == null or is_attacking == true:
		return
		
	var new_grape = GRAPE_BULLET.instantiate()
	new_grape.global_position = shooting_point.global_position
	new_grape.rotation = shooting_point.rotation
	get_tree().root.add_child(new_grape)

func _on_basic_attack_timer_timeout():
	shoot_grape()

# --- STINGER / HOMING ATTACK ---
func trigger_stinger_combo():
	is_attacking = true
	$Sprite2D.texture = homing_sprite 
	
	var dash_speed = player.speed * 0.70 
	
	for i in range(3):
		if player == null:
			break
			
		var target_position = player.global_position
		var distance = global_position.distance_to(target_position)
		var dash_time = distance / dash_speed
		
		var tween = create_tween()
		tween.tween_property(self, "global_position", target_position, dash_time).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
		
		await tween.finished
		await get_tree().create_timer(0.3).timeout

	$Sprite2D.texture = default_sprite
	is_attacking = false

# --- HEALTH & PHASES ---
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

# --- BULLET NOVA ---
func fire_nova(wave_count: int):
	is_attacking = true
	$Sprite2D.texture = nova_sprite
	
	# Loop for however many rounds the phase dictates
	for round_num in range(wave_count):
		
		# Spawn 16 bullets in a perfect circle
		for i in range(16):
			var bullet = NOVA_BULLET.instantiate()
			bullet.global_position = global_position
			# TAU is 360 degrees. Dividing by 16 gives perfect spacing
			bullet.rotation = i * (TAU / 16.0) 
			get_tree().root.add_child(bullet)
			
		# Add a delay between bursts if shooting multiple waves
		if wave_count > 1:
			await get_tree().create_timer(0.5).timeout
			
	$Sprite2D.texture = default_sprite
	is_attacking = false

func die():
	queue_free()

@onready var dash_hitbox = $DashHitbox
