extends Button
export (bool) var mover
func _ready():
	if mover:
		$AnimationPlayer.play("escalar")

func _on_Idioma_button_down():
	$AudioStreamPlayer.play()
	if Global.idioma < len(Global.idiomas)-1:
		Global.idioma += 1
		TranslationServer.set_locale(Global.idiomas[Global.idioma])
		Global.guardar()
	else:
		Global.idioma = 0
		TranslationServer.set_locale(Global.idiomas[Global.idioma])
		Global.guardar()
		
func _process(_delta):
	if get_tree().paused:
		if mover:
			$AnimationPlayer.playback_speed = 0
	else:
		if mover and $AnimationPlayer.playback_speed == 0:
			$AnimationPlayer.playback_speed = 1
			$AnimationPlayer.play("escalar")
	if text != Global.idiomas[Global.idioma]:
		text = Global.idiomas[Global.idioma] 
