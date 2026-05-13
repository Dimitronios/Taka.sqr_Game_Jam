extends Node2D

const MAX_MOBS = 10

var mob_count = 0

func spawn_mob():
	if mob_count >= MAX_MOBS:
		return
	%PathFollow2D.progress_ratio = randf()
	var new_mob = preload("res://mob.tscn").instantiate()
	new_mob.global_position = %PathFollow2D.global_position
	add_child(new_mob)
	mob_count += 1
	new_mob.tree_exited.connect(_on_mob_tree_exited)
	
func _on_mob_tree_exited():
	mob_count -= 1

func _on_timer_timeout():
	spawn_mob()


func _on_player_health_depleted():
	%GameOver.show()
	get_tree().paused = true


func _on_timer_2_timeout() -> void:
	print("Time's up! You survived!")
	end_game()
func end_game():
	get_tree().paused=true 

@onready var game_timer = $Timer2
@onready var time_label = $CanvasLayer/TimeLabel

func _process(_delta):
	if game_timer and time_label:
		var time_left = int(game_timer.time_left)
		var minutes = time_left / 60
		var seconds = time_left % 60
		time_label.text = "%02d:%02d" % [minutes, seconds]
		
