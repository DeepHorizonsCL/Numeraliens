extends CanvasLayer

func _ready():
	$Distorcion.material.set("shader_param/shake_rate", 0.1)
	$Distorcion.visible = true

func Shake():
	$Distorcion.visible = true
	
func Stop():
	$Distorcion.visible = false
	
func OneShot():
	$Distorcion.visible = true
	$Distorcion.material.set("shader_param/shake_rate", 1)
	$Timer.start()
