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
func _on_choise_1_pressed() -> void:
	var poseidon_trident = get_poseidon_trident()
	if poseidon_trident:
		poseidon_trident.visible = true
		poseidon_trident.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = false
	flag = true

func _on_choise_2_pressed() -> void:
	var Mjölnir = get_Mjölnir()
	if Mjölnir:
		Mjölnir.visible = true
		Mjölnir.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = false
	flag = true

func _on_choise_3_pressed() -> void:
	var Bow_apollo = get_Bow_apollo()
	if Bow_apollo:
		Bow_apollo.visible = true
		Bow_apollo.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = false
	flag = true

func get_poseidon_trident():
	for weapon in weapons:
		if weapon.name == "poseidon_trident":
			return weapon
	return null

func get_Bow_apollo():
	for weapon in weapons:
		if weapon.name == "Bow_apollo":
			return weapon
	return null
	
func get_Mjölnir():
	for weapon in weapons:
		if weapon.name == "Mjölnir":
			return weapon
	return null
