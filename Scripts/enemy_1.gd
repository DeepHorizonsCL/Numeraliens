extends Node2D

export var numero = 2
var speed = 50
var basespeed = 0
var speed_subida_golpe = 75
var atacando = false
var irreductible = false

export var zigzageo = false
var speed_zig = 65
var zigzageo_dir = "nulo"
var estado = "bajando"
var muerto = false

var control
var nave

var explosion = preload("res://Particles/Explosion.tscn")
var mininum = preload("res://Objects/Enemys/num_mini.tscn")
var enemyabsorb = preload("res://Objects/Enemys/Enemy1_Absorb.tscn")

var shock
# warning-ignore:unused_signal
signal enemyVictory

var playback = AnimationNodeStateMachinePlayback
# Called when the node enters the scene tree for the first time.
func _ready():
	#print ("my name is " + str(name))
	shock = get_tree().root.get_node("Escena/shock")
	
	#shock.shock($Sprite.get_global_transform_with_canvas().origin)
	$Area2D.add_to_group("enemys")
	playback = $AnimationTree_arana.get("parameters/playback")
	playback.start("stand")
	update_num()
	
func getControl(controlpath):
	if controlpath != "":
		control = get_node_or_null(controlpath)
	
func getNave(navepath):
	if navepath != "":
		nave = get_node_or_null(navepath)
	
	
func _physics_process(delta):
	match estado:
		"bajando":
			position.y += (basespeed + speed) * delta
			
			if zigzageo:
				match zigzageo_dir:
					"der":
						position.x += speed_zig * delta
					"izq":
						position.x -= speed_zig * delta
				 
			
		"subiendo":
			position.y -= speed_subida_golpe * delta
			

func update_num():
	playback.start("muerte")
	if numero > 99:
		numero = 99
		
	if numero < -99:
		numero = -99
		
	var numeropositivo = abs(numero)
	UpdateColorAndSpeed(numeropositivo)
	
	if numero == 0:
		estado = "muerto"
		irreductible = true
		#playback.start("muerte")
		#$TimerMuerte.start() #para esperar un rato a la  muerte
		destroy()
	$numero.text = str(numero)	
	
func UpdateColorAndSpeed(numposi):
	
	if numposi < 10:
		$numero.add_color_override("font_color", Color(1,1,1,1))
		speed = 50
	
	if numposi > 10:
		$numero.add_color_override("font_color", Color(1,0.3,0.3,1))
		speed = 60
	
	if numposi > 20:
		$numero.add_color_override("font_color", Color(1,0,0,1))
		speed = 65
		
	if numposi > 30:
		$numero.add_color_override("font_color", Color(1,0,0,1))
		speed = 70
		
	if numposi > 40:
		#$numero.add_color_override("font_color", Color(1,0,0,1))
		speed = 80
		
	if numposi > 50:
		#$numero.add_color_override("font_color", Color(1,0,0,1))
		speed = 100
		
	if numposi > 60:
		#$numero.add_color_override("font_color", Color(1,0,0,1))
		speed = 120
		
	if numposi > 70:
		#$numero.add_color_override("font_color", Color(1,0,0,1))
		speed = 150
			
	if numposi > 80:
		#$numero.add_color_override("font_color", Color(1,0,0,1))
		speed = 180
	
	if numposi > 90:
		#$numero.add_color_override("font_color", Color(1,0,0,1))
		speed = 200
	
func update_num_specific(num):
	$numero.text = str(num)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func restar(num):
	$DamageSFX.play()
	numero -= num
	update_num()
	
func sumar(num):
	$DamageSFX.play()
	numero += num
	update_num()
	

func destroy():
	shock.shock(self.get_global_transform_with_canvas().origin)
	var explosion1 = explosion.instance()
	get_parent().add_child(explosion1)
	explosion1.position = position
	# actualizando score 
	Global.score += 30
	if Global.score > Global.max_score:
		Global.max_score = Global.score
	queue_free()
	



func _on_Area2D_body_entered(body):
	#print("toque algo...")
	
	var operatoria = Global.operatoria
	
	if irreductible == false:
		if body.is_in_group('num_block'):
			#print("es un bloque, hacer " + str(numero) +" "+  str(operatoria) + " " + str(body.numero))
			

			if operatoria == "+":
				sumar(body.numero)
				createMiniNum("+",body.numero)
			else:
				restar(body.numero)
				createMiniNum("-",body.numero)
			
			body.destroy()
			
			if estado == "bajando" or estado == "quieto":
				playback.start("muerte")
				estado = "subiendo"
				atacando = false
				$TimerGolpe.start()
			
		
		if body.is_in_group("tope"):
			#print(" toque un tope Llegue abajo")
			if body.funca:
				estado = "quieto"
				if atacando == false:
					atacando = true
					attack()
				
	if body.is_in_group("borde"):
		match zigzageo_dir:
			"der":
				zigzageo_dir = "izq"
			"izq":
				zigzageo_dir = "der"
	
	if body.is_in_group("irreduct"):
		#emit_signal("enemyVictory")
		speed = 285
		estado = "bajando"
		irreductible = true
		
	if body.is_in_group("block_destructor"):
		queue_free()
		print("fuera de la pantalla me destruyo " + str(name))
		
func _on_Area2D_area_entered(area):
	if area.is_in_group("enemys") and area.get_parent().irreductible == false and irreductible == false: 
		#print ("!!!!!!!!!!!!-----___toque a otro enemigo___-----!!!!!!!!!!!!")
		print("otro numero: " + str(area.get_parent().numero) )
		
		print (str(position.y) < str(area.get_parent().position.y) )
		
		if  position.y < area.get_parent().position.y :
			var absorb = enemyabsorb.instance()
			get_parent().add_child(absorb)
			absorb.position = position
			absorb.target = area.get_parent()
			queue_free()
		else:
			numero = numero + area.get_parent().numero
			if area.get_parent().numero > 1 :
				createMiniNum("+",area.get_parent().numero)
			else:
				createMiniNum("-",area.get_parent().numero)
			update_num()

func attack():
	print("Ataco " + str(numero) )
	$AttackSFX.play()
	if estado != "muerto":
		if $TimerAttack.wait_time > 0.12:
			$TimerAttack.wait_time -= 0.012
			
		var quitar_vida = abs(numero)
		
		if atacando:
			if control != null:
				if control.perder:
					atacando = false
				get_tree().root.get_node("/root/Escena/Distorcion").OneShot()
				$Chispas.emitting = true
				control.vida -= quitar_vida
				control.update_life()
				
					
		$TimerAttack.start()
	

func _on_TimerAttack_timeout():
	attack()


func _on_TextureButton_pressed():
	
	if numero > 0 and numero <11:
		restar(1)
		createMiniNum("-",1)
		nave.apuntarTorretas(global_position)
		
	elif numero < 0 and numero > -11:
		sumar(1)
		createMiniNum("+",1)
		nave.apuntarTorretas(global_position)


func createMiniNum(signo,num):
	var numMini = mininum.instance()
	get_parent().add_child(numMini)
	numMini.position = position
	numMini.set_text( signo + str(num) )



func _on_TimerGolpe_timeout():
	if estado == "subiendo":
		#Volver animacion normal
		playback.start("stand")
		estado = "bajando"


func _on_enemy_enemyVictory():
	speed = 285
	estado = "bajando"
	irreductible = true





func _on_TimerMuerte_timeout():
	destroy()
