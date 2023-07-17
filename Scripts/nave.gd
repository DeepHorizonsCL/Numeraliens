extends Node2D

var retorna = false

func _ready():
	$nave_torreta/DisparoLaser.playing = true
	$nave_torreta2/DisparoLaser.playing = true
	#$AnimationPlayer2.play("mov")
	$flama2.play("flama")
	
func apuntarTorretas(point):
	#print ("point "+ str(point))
	$nave_torreta.look_at(point)
	$nave_torreta2.look_at(point)
	$nave_torreta/DisparoLaser.visible = true
	$nave_torreta2/DisparoLaser.visible = true
	$ApagarDisparos.start()
	$Retorna.start()
	retorna = false

func _process(delta):
	if retorna:
		if abs($nave_torreta2.rotation_degrees + 90)> 0.05 or abs($nave_torreta.rotation_degrees + 90)> 0.05:
			$nave_torreta2.rotation = lerp_angle($nave_torreta2.rotation,deg2rad(-90),3*delta)
			$nave_torreta.rotation = lerp_angle($nave_torreta.rotation,deg2rad(-90),3*delta)
		else:
			retorna = false

func _on_ApagarDisparos_timeout():
	$nave_torreta/DisparoLaser.visible = false
	$nave_torreta2/DisparoLaser.visible = false


func _on_Retorna_timeout():
	retorna = true
