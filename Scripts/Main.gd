extends Node2D

var screen = Vector2(700.0,1500.0) #tamaño pantalla proyecto
onready var admob = $AdMob

#var sobraX

# Called when the node enters the scene tree for the first time.
func _ready():
	loadAds()
	$Menu/Control/MaxScore.text = String(Global.max_score)
	VisualServer.set_default_clear_color(Color(0,0,0,1))

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
	var bannesize = admob.get_banner_dimension()
	var factor = factor_escala(screenOS,screen)
	var sobra = OS.window_size.y - OS.window_size.x*DefaultFactor
	# si es negativo
	if sobra < 0:
		sobra = 0
	bannesize.y = bannesize.y+20
	var falta = bannesize.y-sobra
	print(bannesize)
	var zoom = $Camera2D.zoom.y
	if sobra <= bannesize.y:
		print('entra')
		zoom = (screen.y + falta/factor) / screen.y
		$Camera2D.zoom.x = zoom
		$Camera2D.zoom.y = zoom
		
		factor = factor_escala(screenOS*zoom,screen)
		sobra = bannesize.y
		var aux = sobra/factor
		$Camera2D.offset.y = -(aux/2)
		$MenuPausa/Pausa.margin_top = -732 + aux
		$MenuPausa/Pausa.margin_bottom = $MenuPausa/Pausa.margin_top + 75
	else:
		zoom = 1
		$Camera2D.zoom.x = zoom
		$Camera2D.zoom.y = zoom
		$Camera2D.offset.y = -(sobra/2)/factor

func loadAds() -> void:
	admob.load_banner()
	admob.load_interstitial()
	admob.load_rewarded_video()

func _on_AdMob_banner_loaded():
	print('cargado el banner')
	admob.show_banner()
	vista_banner()

func _on_AdMob_interstitial_loaded():
	print('cargado el interstitial')

func _on_AdMob_rewarded_video_loaded():
	print('cargado el rewarded_video')

func _on_AdMob_rewarded_video_failed_to_load(error_code):
	print('reward load error:',error_code)

func _on_AdMob_interstitial_failed_to_load(error_code):
	print('interstitial load error:',error_code)

func _on_AdMob_banner_failed_to_load(error_code):
	print('banner load error:',error_code)

func _on_BANNER_button_down():
	admob.hide_banner()



