extends Node2D
var pause_scene = preload("res://pause.tscn")
var pause_menu_instance = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
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
		#for weapon in weapons:
			#weapon.process_mode = Node.PROCESS_MODE_PAUSABLE
		if pause_menu_instance == null:
			pause_menu_instance = pause_scene.instantiate()
			get_tree().root.add_child(pause_menu_instance)
