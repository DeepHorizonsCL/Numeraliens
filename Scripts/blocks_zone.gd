extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_blocks_zone_body_entered(body):
	if body.is_in_group('num_block'):
		body.enzona = true

func _on_blocks_zone_body_exited(body):
	if body.is_in_group('num_block'):
		body.enzona = false
