extends Control

func _ready() -> void:
	pass 

func _process(delta: float) -> void:
	pass
	
func _on_quit_pressed() -> void:
	get_tree().paused = false
	get_tree().quit()


func _on_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://survivors_game.tscn")
