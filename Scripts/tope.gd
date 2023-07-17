extends KinematicBody2D

var funca = true
export (NodePath) var controlPath
onready var control = get_node(controlPath)


func addVida(point):
	if not control.perder:
		control.addVida(point)
