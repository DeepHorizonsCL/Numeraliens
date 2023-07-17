extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
var active = false
export var speed = 412
var Posini = Vector2(0,0)

func resetpos():
	position = Posini

# Called when the node enters the scene tree for the first time.
func _ready():
	Posini = position

func _process(delta):
	if active:
		position.y -= speed * delta
