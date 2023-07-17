extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var admob = get_node("/root/Escena/AdMob")
var conteo = 10
onready var controller =  get_node("/root/Escena/bloques")
var contando = false

# Called when the node enters the scene tree for the first time.
func _ready():
	setInvisibility()

func setInvisibility():
	$Panel.visible = false
	$ColorRect.visible = false
	$GameOver.visible = false
	$CuentaRegresiva.visible = false
	
func cuentatras():
	$CuentaRegresiva/Control/numero.modulate = Color(1,1,1,1)
	$CuentaRegresiva/AnimationPlayer.play("continuar")
	conteo = 10
	updateConteo()
	contando = true
	$Panel.visible = false
	$CuentaRegresiva.visible = true
	$CuentaRegresiva/Disminucion.start()
	

func show():
	contando = false
	$CuentaRegresiva.visible = false
	$ColorRect.visible = true
	$GameOver.visible = true
	$Panel.visible = true
	$Panel/Max.text = String(Global.max_score)
	$Panel/Actual.text = String(Global.score)


func _on_Volver_button_down():
	admob.show_interstitial()
# warning-ignore:return_value_discarded
	Global.score = 0
	get_tree().root.get_node("Escena/Distorcion/Distorcion").material.set("shader_param/view", false)
	get_tree().reload_current_scene()


func _on_Disminucion_timeout():
	if contando:
		if conteo > 1:
			conteo -= 1
			updateConteo()
		else:
			show()
		$CuentaRegresiva/Disminucion.start()


func updateConteo():
	if conteo < 4:
		$CuentaRegresiva/Control/numero.modulate = Color(1,0,0,1)
		$number_Down2.play()
	$CuentaRegresiva/Control/numero.text = str(conteo)
	$number_Down.play()


func _on_Revivir__pressed():
	print ("volver al juego")
	Global.continuaciones += 1
	contando = false
	Global.score -= Global.costeContinue
	Global.costeContinue += 150 
	if controller:
		controller.Continue()
		setInvisibility()
	admob.show_interstitial()


func _on_Sailr_pressed():
	print ("morir")
	show()
