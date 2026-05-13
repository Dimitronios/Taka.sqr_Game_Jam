extends CanvasLayer

func _ready():
	pass

func _input(event):
	if event.is_action_pressed("ui_accept"):
		go_to_menu()

func _on_button_pressed():
	go_to_menu()

func go_to_menu():
	get_tree().change_scene_to_file("res://main_menu.tscn")
