extends TextureRect

export(Texture) var t1
export(Texture) var t2

export(Texture) var a1
export(Texture) var a2

var b = "dificultad"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_arrow_r_pressed():
	print("pressed arrow r")
	arrow_pressed()

func _on_arrow_l_pressed():
	print("pressed arrow l")
	arrow_pressed()

func arrow_pressed():
	if Global.extremo:
		Global.extremo = false
		$txt_extreme.text = "LABEL_NORMAL"
		texture = t1
		$txt_extreme.modulate = Color(255,255,255)
		#$arrow_r.icon = a1
		#$arrow_l.icon = a1
	else:
		Global.extremo = true
		$txt_extreme.text = "LABEL_EXTREME"
		texture = t2
		$txt_extreme.modulate =  Color(255,214,214)
		#$arrow_r.icon = a2
		#$arrow_l.icon = a2
