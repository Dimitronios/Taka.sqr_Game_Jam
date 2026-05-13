extends Node2D
var pause_scene = preload("res://pause.tscn")
var pause_menu_instance = null
var win1 = preload("res://survived.tscn")
var win1_show_instance = null
var death_scene = preload("res://death.tscn")
var death_show_instance = null
const MAX_MOBS = 10
var count_waves = 1
var mob_count = 0
var win2 = preload("res://survived2.tscn")
var win2_show_instance = null
var win3 = preload("res://survived3.tscn")
var win3_show_instance = null



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
	get_tree().paused = true
	death_show_instance = death_scene.instantiate()
	get_tree().root.add_child(death_show_instance)
	
func start_new_round():
	count_waves += 1
	reset_timer()
	reset_player()
	respawn_mobs()

func _on_timer_2_timeout() -> void:
	end_game()
	if count_waves == 1:
		win1_show_instance = win1.instantiate()
		get_tree().root.add_child(win1_show_instance)
	elif count_waves == 2:
		win2_show_instance = win2.instantiate()
		get_tree().root.add_child(win2_show_instance)
	elif count_waves == 3:
		win3_show_instance = win3.instantiate()
		get_tree().root.add_child(win3_show_instance)
func end_game():
	get_tree().paused=true 

@onready var game_timer = $Timer2
@onready var time_label = $CanvasLayer/TimeLabel

func respawn_mobs():
	pass

func reset_player():
	$Player.hp = $Player.max_hp

func reset_timer():
	$Timer2.stop()
	$Timer2.wait_time += 0.3
	$Timer2.start()

func _process(_delta):
	if game_timer and time_label:
		var time_left = int(game_timer.time_left)
		var minutes = time_left / 60
		var seconds = time_left % 60
		time_label.text = "%02d:%02d" % [minutes, seconds]
		if Input.is_action_just_pressed("ui_cancel"):
			toggle_pause()
func toggle_pause():
	if get_tree().paused:
		get_tree().paused = false
		if pause_menu_instance:
			pause_menu_instance.queue_free()
			pause_menu_instance = null
	else:
		get_tree().paused = true
		if pause_menu_instance == null:
			pause_menu_instance = pause_scene.instantiate()
			get_tree().root.add_child(pause_menu_instance)
