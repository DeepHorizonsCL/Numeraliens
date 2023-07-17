extends Node2D

var screen = Vector2(700.0,1500.0) #tamaño pantalla proyecto

#var sobraX

# Called when the node enters the scene tree for the first time.
func _ready():
	#VisualServer.set_default_clear_color(Color(0,0,0,1))
	pass

func factor_escala(screenOS:Vector2, Proyecto:Vector2):
	# factor en ancho y alto
	var FactorX = screenOS.x/Proyecto.x
	var FactorY = screenOS.y/Proyecto.y
	# si ancho es mayor que alto
	var factor = FactorX
	if FactorX > FactorY:
		factor = FactorY #factor por el cual se dimensionan las cosas
	return factor
	
func vista_banner():
	var DefaultFactor = screen.y/screen.x
	var screenOS = Vector2(OS.window_size.x,OS.window_size.y)
	var factor = factor_escala(screenOS,screen)
	var zoom = $Camera2D.zoom.y
	var sobra = OS.window_size.y - OS.window_size.x*DefaultFactor
	zoom = 1
	$Camera2D.zoom.x = zoom
	$Camera2D.zoom.y = zoom
	$Camera2D.offset.y = -(sobra/2)/factor

