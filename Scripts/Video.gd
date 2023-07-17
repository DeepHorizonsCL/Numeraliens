extends CanvasLayer


var videos = [
	"res://Videos/tutorial_vid1.ogv",
	"res://Videos/tutorial_vid2.ogv",
	"res://Videos/tutorial_vid3.ogv",
	"res://Videos/tutorial_vid4.ogv",
	"res://Videos/tutorial_vid5.ogv",
	"res://Videos/tutorial_vid6.ogv"
]

onready var texts = [
	$Panel/text1,
	$Panel/text2,
	$Panel/text3,
	$Panel/text4,
	$Panel/text5,
	$Panel/text6
]

var indice = 0

onready var Video = $Panel/VideoPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Video")
	$Panel/replay/AnimationPlayer.play("stop")
	playVideo()
	
	
func playVideo():
	Video.stream = load(videos[indice])
	print(Video.stream)
	Video.play()
	setTextVisible(indice)
	
	print ("indice ", indice)
	
	if indice < 1:
		$Panel/replay/arrow_l.disabled = true
	else:
		$Panel/replay/arrow_l.disabled = false
		
	if indice > 4:
		$Panel/replay/arrow_r.disabled = true
	else:
		$Panel/replay/arrow_r.disabled = false
	

	
	
func setTextVisible(index):
	var iterator = 0
	for text in texts:
		print ("texto ", text)
		if iterator == index:
			text.visible = true
		else: 
			text.visible = false

		iterator +=1


func _on_VolverMenu_pressed():
	Global.cambioOtraEscena("Escena")


func _on_extreme_pressed():
	Video.play()


func _on_arrow_l_pressed():
	if (indice > 0):
		indice -= 1
	playVideo()


func _on_arrow_r_pressed():
	if (indice < 5):
		indice += 1
	playVideo()


func _on_VideoPlayer_finished():
	$Panel/replay/AnimationPlayer.play("replay")
