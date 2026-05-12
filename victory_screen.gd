extends CanvasLayer

func _ready():
	# If you made a button, connect its pressed signal:
	# $Button.pressed.connect(_on_button_pressed)
	pass

# Pro tip: Listen for keyboard input (like Enter/Space) as well
func _input(event):
	if event.is_action_pressed("ui_accept"):
		go_to_menu()

func _on_button_pressed():
	go_to_menu()

func go_to_menu():
	# Make sure you set your game to process while paused so this works!
	# replace with your actual main menu path
	get_tree().change_scene_to_file("res://main_menu.tscn")
