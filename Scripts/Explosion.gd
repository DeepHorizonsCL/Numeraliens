extends Node2D

func _ready():
	$ouch.play()
	$fuego.emitting = true
	$fuego/chispa.emitting = true
	$fuego/humo.emitting = true


func _on_Timer_timeout():
	queue_free()


func set_volume(num):
	$ExplosionSFX.volume_db = num 


func silenciar():
	$ouch.volume_db = -80
	
