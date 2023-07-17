extends Node2D

var Enemy1_path = preload("res://Objects/Enemys/Enemy1.tscn")
export (NodePath) var control_path = ""
export (NodePath) var nave_path = ""
var iteraciones = 0
var basespeed = 0

var limi_inf = 1
var limi_sup = 12

var puedocrear = true

var cantidadcrear = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func create_random():
	var Enemy1 = Enemy1_path.instance()
	get_parent().add_child(Enemy1)
	
	Enemy1.numero = randi() % limi_sup + limi_inf
	Enemy1.getControl(control_path)
	Enemy1.getNave(nave_path)
	Enemy1.basespeed = basespeed
	
	
	var signo = randi() % 8 + 1
	
	var zigzag = randi() % 12 + 1
	
	if zigzag > 8:
		Enemy1.zigzageo = true
		Enemy1.zigzageo_dir = "izq"
		if zigzag > 10:
			Enemy1.zigzageo_dir = "der"
	
	if signo < 4:
		Enemy1.numero *= -1
		
	Enemy1.update_num()
	
	
	#aparece de forma random
	Enemy1.position = Vector2(rand_range($creator1.global_position.x, $creator4.global_position.x), $creator1.global_position.y)
	
func create_(num):
	var Enemy1 = Enemy1_path.instance()
	get_parent().add_child(Enemy1)

	match num:
		1:
			Enemy1.position  = $creator1.global_position
			
		2:
			Enemy1.position  = $creator2.global_position
			
		3: 
			Enemy1.position  = $creator3.global_position
			
		4: 
			Enemy1.position  = $creator4.global_position

	
func reset_iteraciones():
	iteraciones = 0
	limi_inf = 1
	limi_sup = 10
	basespeed = 0
	$TimerEnemy.start()
	$TimerItera.start()
	puedocrear = true

func Dificultad_iteration():
	iteraciones += 1
	get_tree().root.get_node("/root/Escena/Background/estrellas").speed += 1.45
	
	
	if iteraciones >= 2 and iteraciones < 4:
		limi_sup = 12
		limi_inf = 1
	elif iteraciones >= 4 and iteraciones < 8:
		limi_sup = 20
		limi_inf = 5
	elif iteraciones >= 8 and iteraciones < 16:
		cantidadcrear = 2
		limi_sup = 25
		limi_inf = 10
	elif iteraciones > 16 and iteraciones < 20:
		limi_sup = 30
		limi_inf = 12
	elif iteraciones >= 20 and iteraciones < 24:
		limi_sup = 35
		limi_inf = 16
	elif iteraciones >= 24 and iteraciones < 28:
		limi_sup = 40
		limi_inf = 20
	elif iteraciones >= 28 and iteraciones < 32:
		cantidadcrear = 3
		limi_sup = 45
		limi_inf = 25
	elif iteraciones >= 32 and iteraciones < 36:
		limi_sup = 50
		limi_inf = 30
	elif iteraciones >= 36 and iteraciones < 40:
		limi_sup = 55
		limi_inf = 35
	elif iteraciones >= 40 and iteraciones < 44:
		cantidadcrear = 4
		limi_sup = 60
		limi_inf = 40
	elif iteraciones >= 44 and iteraciones < 48:
		limi_sup = 64
		limi_inf = 45
	elif iteraciones >= 48 and iteraciones < 52:
		limi_sup = 70
		limi_inf = 50
	elif iteraciones >= 52 and iteraciones < 56: 
		cantidadcrear = 5
		limi_sup = 75
		limi_inf = 55
	elif iteraciones >= 56 and iteraciones < 60: 
		cantidadcrear = 6
		limi_sup = 85
		limi_inf = 65
	elif iteraciones >= 60 and iteraciones < 64: 
		cantidadcrear = 7
		limi_sup = 99
		limi_inf = 80
	elif iteraciones >= 64: 
		cantidadcrear = 8
		limi_sup = 99
		limi_inf = 99
	basespeed += 0.25
	
	print("Iteracion " + str(iteraciones) + "[" + str(limi_sup) +" - " +  str(limi_inf) + "]: " + str(cantidadcrear) )


func _on_TimerEnemy_timeout():
	var creados = 0
	
	if puedocrear == true:
		while creados < cantidadcrear:
			creados += 1
			create_random()
	$TimerEnemy.start()


func _on_TimerItera_timeout():
	Dificultad_iteration()
	
	var timetoreduc = $TimerItera.wait_time 
	if timetoreduc > 0.25:
		$TimerItera.wait_time -= 0.024
		
	print ("iterar denuevo en tiempo " + str(timetoreduc))

	$TimerItera.start()
