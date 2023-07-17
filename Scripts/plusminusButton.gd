extends Button

export var symbol = "+"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	changesymbol(symbol)

func changesymbol(change):
	if change == "+" :
		$plus.visible = true
		$minus.visible = false
		$button_sign_upper.modulate = Color("47ff4a")
		symbol = "+"
	elif change == "-":
		$plus.visible = false
		$minus.visible = true
		$button_sign_upper.modulate = Color("ff4d4f")
		symbol = "-"
	Global.operatoria = symbol
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func toglesymbol():
	if symbol == "+":
		changesymbol("-")
	elif symbol == "-":
		changesymbol("+")

func _on_Button_pressed():
	toglesymbol()
