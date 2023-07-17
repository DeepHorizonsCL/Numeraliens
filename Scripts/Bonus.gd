extends KinematicBody2D

export var xvidas = 5
export var speed = 100
var _giro = rand_range(2,6)

func _ready():
	pass # Replace with function body.

func _process(delta):
	var _a = move_and_slide(Vector2.DOWN*speed,Vector2.UP)
	rotation += delta*_giro
	
	for x in get_slide_count():
		var col = get_slide_collision(x)
		col = col.collider
		if col.is_in_group("tope"):
			col.addVida(xvidas)
			queue_free()

