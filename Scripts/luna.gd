extends Node2D

var dir = 1
var speed = 12
export (NodePath) var planetpath
export var escalaMaxima = 1.85
export var escalaMinima = 0.25
var escala = 1
var planeta

# Called when the node enters the scene tree for the first time.
func _ready():
	planeta = get_node(planetpath)
	$Spr_lunita.scale.x = escala 
	$Spr_lunita.scale.y = escala 

func _process(delta):
	position.x += speed * delta * dir
	
	var dis = planeta.global_position.x - global_position.x
	#print (" pos " + str(dis) + " escala " + str(escala) )
	
	if dis > 0:
		if escala < escalaMaxima:
			escala += 0.00032
	else:
		if escala > escalaMinima:
			escala -= 0.00032
				
	$Spr_lunita.scale.x = escala 
	$Spr_lunita.scale.y = escala 

func _on_Cambio_timeout():
	dir *= -1
	if dir == 1:
		z_index = 0
	elif dir == -1:
		z_index = -1
	
	$Cambio.start()
