extends Node2D

var speed = 50
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _process(delta):
	position.y -= speed * delta


func set_text(texto):
	$num_mini.text = texto

func _on_Destroy_timeout():
	queue_free()
