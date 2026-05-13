extends CanvasLayer

@onready var health_bar = $BossHealthBar
@onready var hp_label = $BossHealthBar/HPLabel

@onready var boss = %Boss 

func _ready():
	if boss and health_bar:
		boss.health_changed.connect(_on_boss_health_changed)
		
		health_bar.max_value = boss.max_health
		health_bar.value = boss.current_health
		
		if hp_label:
			hp_label.text = str(boss.current_health) + " / " + str(boss.max_health)
	else:
		if not boss: print("UI ERROR: Boss node not found!")
		if not health_bar: print("UI ERROR: BossHealthBar node not found!")

func _on_boss_health_changed(current, max_hp):
	if health_bar:
		health_bar.max_value = max_hp
		health_bar.value = current
	
	if hp_label:
		hp_label.text = str(current) + " / " + str(max_hp)
