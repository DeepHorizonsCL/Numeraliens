extends Node2D

var vida = 100

var bloque1
var bloque2
var bloque3

var perder = false
var explosion = preload("res://Particles/Explosion.tscn")

var bajarVolExplosiones = false
var nave_explotando = false

export (NodePath) var MenuPath
export (NodePath) var TimerEnemyPath
export (NodePath) var topePath
export (NodePath) var irreducPath 
export (NodePath) var EnemyCreatorPath
export (NodePath) var bgpspacePath
export (NodePath) var planetPath
export (NodePath) var barraVidaPath

onready var Menu = get_node(MenuPath)
onready var TimerEnemy = get_node(TimerEnemyPath)
onready var admob = get_node("/root/Escena/AdMob")
onready var puntaje = get_node("/root/Escena/Puntaje")
onready var tope = get_node(topePath)
onready var irreduc = get_node(irreducPath)
onready var EnemyCreator = get_node(EnemyCreatorPath)
onready var bgspace = get_node(bgpspacePath)
onready var planet = get_node(planetPath)
onready var barraVida = get_node(barraVidaPath)


# Called when the node enters the scene tree for the first time.
func _ready():
	print ("continuaciones " + str(Global.continuaciones))
	Global.costeContinue = 50
	randomize()
	$AnimationPlayer.play("mov")

	Global.extremo = false
	bloque1 = $ArrasBloque1
	bloque2 = $ArrasBloque2
	bloque3 = $ArrasBloque3
	
	get_parent().get_node("Musica_pocaVida1").stop()
	get_parent().get_node("Musica_pocaVida2").stop()


func addVida(puntos):
	vida = clamp(vida + puntos, 0, 100)
	update_life()


func update_life():
	barraVida.value = vida
	if vida > 40:
		get_parent().get_node("Musica_pocaVida1").volume_db = -40
		get_parent().get_node("Musica_pocaVida2").volume_db = -40
	elif vida > 25:
		get_parent().get_node("Musica_pocaVida1").volume_db = -4
		get_parent().get_node("Musica_pocaVida2").volume_db = -40
	else:
		print("le entra")
		var naveAnim = get_tree().root.get_node("Escena/Background/nave/AnimationPlayer")
		naveAnim.play("alert")
		get_parent().get_node("Musica_pocaVida1").volume_db = -40
		get_parent().get_node("Musica_pocaVida2").volume_db = -4
		
	if vida < 1:
		Global.guardar()
		Global.perder = true
		visible = false
		get_parent().get_node("Musica_pocaVida1").volume_db = -40
		get_parent().get_node("Musica_pocaVida2").volume_db = -40
		if perder == false:
			perder = true
			tope.funca = false
			irreduc.active = true
			nave_explotando = true
			$Explosiones.start()
			$GameOver.start()
			get_parent().get_node("Sonido_Alarma").play()
		#admob.show_interstitial()
		#warning-ignore:return_value_discarded #comentado desde antes
		#get_tree().reload_current_scene()


func GameOver():
	bajarVolExplosiones = true
	if Global.extremo:
		puntaje.show()
	else:
		print("Score: " + str(Global.score) + " coste: " + str(Global.costeContinue))
		if Global.score > Global.costeContinue:
			puntaje.cuentatras()
		else:
			puntaje.show()
	#$"/root/Escena/GameOver".play()
	get_parent().get_node("Musica").stop()
	get_parent().get_node("Musica_pocaVida1").stop()
	get_parent().get_node("Musica_pocaVida2").stop()
	get_parent().get_node("Sonido_Alarma").stop()
	EnemyCreator.puedocrear = false
	Global.menu_inicio = true
	visible = false


func Continue():
	get_parent().get_node("Musica").play()
	tope.funca = true
	bajarVolExplosiones = false
	EnemyCreator.puedocrear = true
	visible = true
	vida = 30
	perder = false
	nave_explotando = false
	irreduc.active = false
	irreduc.resetpos()
	var naveAnim = get_tree().root.get_node("Escena/Background/nave/AnimationPlayer")
	naveAnim.play("idle")
	update_life()
	


func resetAllBlocks():
	print("resetar los bloques")
	resetBlock(bloque1)
	resetBlock(bloque2)
	resetBlock(bloque3)


func resetBlock(var bloque):
	if bloque != null:
		if bloque.estado == "esperando":
			bloque.resetbloque()
	else:
		print("bloque nulo")


func _on_Button2_pressed():
	resetAllBlocks()


func _on_Start_pressed():
	Global.menu_inicio = false
	visible = true
	Menu.get_node("Control").visible = false
	tope.funca = true
	irreduc.resetpos()
	EnemyCreator.reset_iteraciones()
	#Musica
	$AnimationPlayer.play("Intro")
	get_parent().get_node("Sonido_boton").play()
	get_parent().get_node("Musica_menu").stop()
	
	if Global.extremo:
		get_parent().get_node("Musica_pocaVida2").play()
		get_parent().get_node("Musica_pocaVida2").volume_db = -4
		vida = 1
		update_life()
		bgspace.modulate = Color(0.90,0.12,0.12)
		planet.modulate = Color(0.90,0.12,0.12)
		JavaScript.eval("alert('Calling JavaScript per GDScript!');")
	else:
		get_parent().get_node("Musica").play()
		get_parent().get_node("Musica_pocaVida1").play()
		get_parent().get_node("Musica_pocaVida2").play()
		get_parent().get_node("Musica_pocaVida1").volume_db = -40
		get_parent().get_node("Musica_pocaVida2").volume_db = -40
		
	
	
	get_tree().root.get_node("/root/Escena/Distorcion").Stop()


func _on_Explosiones_timeout():
	if nave_explotando:
		print("Crear explosión")
		var explosion1 = explosion.instance()
		explosion1.silenciar()
		if bajarVolExplosiones:
			explosion1.set_volume(-24)
		get_parent().add_child(explosion1)
		explosion1.position = Vector2(rand_range(100,700),rand_range(1000,1600))
		$Explosiones.start()


func _on_GameOver_timeout():
	print("GAME OVER")
	GameOver()


func _on_extreme_pressed():
	Global.extremo = true
	visible = true
	Menu.get_node("Control").visible = false
	tope.funca = true
	irreduc.resetpos()
	EnemyCreator.reset_iteraciones()
	
	#Musica
	$AnimationPlayer.play("Intro")
	get_parent().get_node("Sonido_boton").play()
	get_parent().get_node("Musica_pocaVida2").play()
	get_parent().get_node("Musica_pocaVida2").volume_db = -4
	get_parent().get_node("Musica_menu").stop()
	get_parent().get_node("Musica").play()
	
	get_tree().root.get_node("/root/Escena/Distorcion").Stop()


func _on_tutorial_pressed():
	print("Cambiar esena ")
	Global.cambioOtraEscena("Video")
	print( get_tree().get_current_scene().get_name() )
