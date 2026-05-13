extends Control
@onready var PauseMenu = $PauseMenu
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if visible == false and Input.is_action_just_pressed("ui_cancel"):
		visible = true


func _on_resume_pressed() -> void:
	get_tree().paused = false
	visible = false




func _on_quit_pressed() -> void:
	get_tree().paused = false
	get_tree().quit()


func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main_menu.tscn")
