extends TextureButton

var cantidad = 25

func _ready():
	pass


func _on_Titulo_button_down():
	cantidad -= 1
	print(cantidad)
	if cantidad < 0:
		$numeraliens.play()
