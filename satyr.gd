extends CharacterBody2D

signal died

var speed = randf_range(350, 450)
var health = 8
@onready var player = get_tree().get_first_node_in_group("player")
@onready var anim = $satyrwalk

func _ready():
	anim.play("walk")

func _physics_process(_delta):
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * speed
	move_and_slide()
	if direction.x > 0:
		$satyrwalk.flip_h = false
	else:
		$satyrwalk.flip_h = true
	


func take_damage(damage_amount):
	health -= damage_amount
	flash_red()
	if health <= 0:
		die()

func flash_red():
	anim.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	anim.modulate = Color.WHITE

func die():
	var tween = create_tween()
	tween.tween_property(anim, "scale", Vector2(1.5, 1.5), 0.1)
	tween.tween_property(anim, "modulate:a", 0.0, 0.1)
	await tween.finished
	queue_free()
