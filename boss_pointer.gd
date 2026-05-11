extends Sprite2D

var margin: float = 40.0
@onready var boss = get_node_or_null("/root/BossLevel/Boss")

func _process(delta):
	if boss == null:
		visible = false
		return
		
	var screen_size = get_viewport_rect().size
	var center = screen_size / 2.0
	
	var boss_screen_pos = boss.get_global_transform_with_canvas().origin
	
	var is_offscreen = boss_screen_pos.x < 0 or boss_screen_pos.x > screen_size.x or boss_screen_pos.y < 0 or boss_screen_pos.y > screen_size.y
	
	if is_offscreen:
		visible = true
		
		var direction = center.direction_to(boss_screen_pos)
		rotation = direction.angle()
		
		var clamped_pos = boss_screen_pos
		clamped_pos.x = clamp(clamped_pos.x, margin, screen_size.x - margin)
		clamped_pos.y = clamp(clamped_pos.y, margin, screen_size.y - margin)
		
		position = clamped_pos
	else:
		visible = false
