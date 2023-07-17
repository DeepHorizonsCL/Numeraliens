extends Sprite


export var speed = 6

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

#export (NodePath) var FondoPath


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# warning-ignore:unused_argument
func _physics_process(delta):
	region_rect.position.y -= speed * delta
