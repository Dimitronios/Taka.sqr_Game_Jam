extends CanvasLayer

# 1. These names MUST match your Scene Tree (left side of your screen)
@onready var health_bar = $BossHealthBar
@onready var hp_label = $BossHealthBar/HPLabel

# 2. Use the %Boss unique name (Right-click Boss node -> Access as Unique Name)
@onready var boss = %Boss 

func _ready():
	# We check if both nodes exist before doing anything to prevent crashes
	if boss and health_bar:
		# Connect the signal for hits
		boss.health_changed.connect(_on_boss_health_changed)
		
		# Set the initial 100% health
		health_bar.max_value = boss.max_health
		health_bar.value = boss.current_health
		
		if hp_label:
			hp_label.text = str(boss.current_health) + " / " + str(boss.max_health)
	else:
		if not boss: print("UI ERROR: Boss node not found!")
		if not health_bar: print("UI ERROR: BossHealthBar node not found!")

func _on_boss_health_changed(current, max_hp):
	# Using 'if health_bar' here prevents the "null instance" crash
	if health_bar:
		health_bar.max_value = max_hp
		health_bar.value = current
	
	if hp_label:
		hp_label.text = str(current) + " / " + str(max_hp)
