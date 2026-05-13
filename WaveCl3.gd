extends Control
var weapons = []
#@onready var shield = %shield_achilles  
var flag = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#print(get_tree().root.get_children())  # τι υπάρχει στο root
	#print(get_node("/root/Survived").get_children())  # τι υπάρχει στο Survived
	weapons = get_tree().get_nodes_in_group("Weapons")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if flag == true:
		get_tree().change_scene_to_file("res://boss_level.tscn")

func _on_choise_1_pressed() -> void:
	var Hou_Yis = get_Hou_Yis()
	if Hou_Yis:
		Hou_Yis.visible = true
		Hou_Yis.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = false
	flag = true


func _on_choise_2_pressed() -> void:
	var Pashupatastra = get_Pashupatastra()
	if Pashupatastra:
		Pashupatastra.visible = true
		Pashupatastra.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = false
	flag = true

func get_Hou_Yis():
	for weapon in weapons:
		if weapon.name == "Hou_Yis":
			return weapon
	return null

func get_Pashupatastra():
	for weapon in weapons:
		if weapon.name == "Pashupatastra":
			return weapon
	return null
	
