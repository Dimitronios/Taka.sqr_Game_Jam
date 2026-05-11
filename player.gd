extends CharacterBody2D

signal health_depleted


@export var max_health: int = 15
@export var speed: float = 600.0
@export var strength: int = 3 # base dmg

var current_health: int
var damage_cooldown: float = 0.0

func _ready():
	current_health = max_health
	%HealthBar.max_value = max_health
	%HealthBar.value = current_health

func _physics_process(delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * speed

	move_and_slide()
	
	if velocity.length() > 0.0:
		%HappyBoo.play_walk_animation()
	else:
		%HappyBoo.play_idle_animation()
	
	if damage_cooldown > 0.0:
		damage_cooldown -= delta
	
	var overlapping_mobs = %HurtBox.get_overlapping_bodies()
   
	if overlapping_mobs.size() > 0 and damage_cooldown <= 0.0:
		
		current_health -= 1 * overlapping_mobs.size()
		%HealthBar.value = current_health
		damage_cooldown = 0.5 
		
		if current_health <= 0:
			health_depleted.emit()
