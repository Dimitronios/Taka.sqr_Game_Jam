extends Control

func _ready() -> void:
	hide() 

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().paused = !get_tree().paused
		
		visible = get_tree().paused

func _on_resume_pressed() -> void:
	get_tree().paused = false
	hide()

func _on_quit_pressed() -> void:
	get_tree().paused = false
	get_tree().quit()

func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main_menu.tscn")
