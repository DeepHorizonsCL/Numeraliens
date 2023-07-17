extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Panel.visible = false
	$Panel/Master.value = Global.volumen_general
	$Panel/Musica.value = Global.volumen_musica
	$Panel/SFX.value = Global.volumen_sfx
	#$Panel/Button/AnimationPlayer.play("default")
	#$Control/MarginContainer/Pausa/AnimationPlayer.play("default")

# Called every frame. 'delta' is the elapsed time since the previous frame.
# warning-ignore:unused_argument
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		_on_Pausa_button_down()

func _on_Master_value_changed(value):
	if value < -35:
		value = -80
	$Panel/Master/MasterProgress.value = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)
	Global.volumen_general = value

func _on_Musica_value_changed(value):
	if value < -35:
		value = -80
	$Panel/Musica/MusicProgress.value = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music_bus"), value)
	Global.volumen_musica = value

func _on_SFX_value_changed(value):
	if value < -35:
		value = -80
	$Panel/SFX/SFXProgress.value = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX_bus"), value)
	Global.volumen_sfx = value


func _on_Pausa_button_down():
	$Panel.visible = !$Panel.visible
	$Salir.visible = $Panel.visible
	$Pausa.visible = !$Panel.visible
	#$Idioma.visible = $Panel.visible
	#$SonidoBotones/avanzar.play()
	
	if not $Panel.visible:
		Global.guardar()
		
	get_tree().paused = $Panel.visible


func _on_Salir_button_down():
	#JavaScript.eval("window.open('https://www.deephorizons.cl/','_self');")
	get_tree().quit()
