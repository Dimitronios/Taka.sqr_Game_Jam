extends Control

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_cancel") and visible == false :
		get_tree().paused = true
		visible = true

func _on_resume_pressed() -> void:
	get_tree().paused = false
	visible = false

func _on_quit_pressed() -> void:
	get_tree().paused = false
	get_tree().quit()

func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	visible = false
	get_tree().change_scene_to_file("res://main_menu.tscn")
