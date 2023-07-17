extends Sprite

func shock(pos):
	$AnimationPlayer.play("wave")
	var center = pos/get_viewport_rect().size
	center.y = 1 - center.y
	var ratio = get_viewport_rect().size.x/get_viewport_rect().size.y
	center.x = range_lerp(center.x,0,1,ratio/2,1-ratio/2)
	material.set_shader_param("center",center)
