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
		get_node("/root/survivors_game.tscn").start_new_round()
func _on_choise_pressed() -> void:
	flag = true
	var kusanagi = get_kusanagi()
	if kusanagi:
		kusanagi.visible = true
		kusanagi.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = false


func _on_choise_2_pressed() -> void:
	flag = true
	var shield = get_shield()
	if shield:
		shield.visible = true
		shield.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = false

func _on_choise_3_pressed() -> void:
	flag = true
	var gungnir = get_gungnir()
	if gungnir:
		gungnir.visible = true
		gungnir.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = false

func get_shield():
	for weapon in weapons:
		if weapon.name == "shield_achilles":
			return weapon
	return null

func get_gungnir():
	for weapon in weapons:
		if weapon.name == "gungnir":
			return weapon
	return null
	
func get_kusanagi():
	for weapon in weapons:
		if weapon.name == "kusanagi":
			return weapon
	return null
