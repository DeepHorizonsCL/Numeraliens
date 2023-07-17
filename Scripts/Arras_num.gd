extends KinematicBody2D

export var numero = 2
var estado = "esperando"
var dragging = false
var rapidez = 1000
var rapidez_respawn = 600
var creadotro = false
var enzona = false
var encima = false
var abajonuevobloque = 165

export var numerodebloque = 0

var posini
var global_posini
var target_y


signal dragsignal
export  (NodePath) var controlpath
var control
var touch = false
var touch_index
var bloquesumado

func _ready():
	
	update_num()
	
	posini = position
	global_posini = global_position
# warning-ignore:return_value_discarded
	connect("dragsignal",self,"_set_drag_pc")
	
	if controlpath != "":
		getControl()
	
func getControl():
	control = get_node_or_null(controlpath)
	
func _process(delta):
	if estado == "volando":
		 global_position.y -= rapidez * delta
	elif estado == "subiendo":
		posini.y = target_y
		#sprint (str(position.y) + " VS " + str(target_y))
		if position.y > target_y:
			position.y -= rapidez_respawn * delta
		else: 
			position.y = posini.y
			estado = "esperando"
	
func update_num_specific(num):
	$numero.text = str(num)
	
func update_num():
	$numero.text = str(numero)
	
	if(numero == 0):
		destroy()
	
func restar(num):
	if numero-num > -99:
		numero -= num
	else:
		numero = -99
	update_num()
	
func sumar(num):
	if numero+num < 99:
		numero += num
	else: 
		numero = 99
	update_num()
	
func destroy():
	if creadotro == false:
		crearbloque()
	queue_free()
	
func anunciar():
	print ("hola soy el bloque " + str(name) + " creado en " + str(position) + " | global " + str(global_position) ) 
	
func _input(event):
	if touch:
		if event is InputEventScreenTouch:
			if event.index == touch_index and not event.pressed:
				touch = false
				emit_signal("dragsignal")
		elif event is InputEventScreenDrag and dragging and event.index == touch_index:
			var mousepos = event.position
			global_position = Vector2(mousepos.x, mousepos.y)
	else:
		if event is InputEventMouseButton and dragging and event.button_index == BUTTON_LEFT and !event.pressed:
			emit_signal("dragsignal")
		elif event is InputEventMouseMotion and dragging:
			var mousepos = get_global_mouse_position()
			global_position = Vector2(mousepos.x, mousepos.y)
	
func _on_ArrasBloque_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			emit_signal("dragsignal")
			
	elif event is InputEventScreenTouch and event.pressed and !touch:
		touch_index = event.index
		self.global_position = event.get_position()
		dragging = true
		touch = true
		
func _set_drag_pc():
	dragging=!dragging
	#print("draggin" + str(dragging))
	if dragging == false and estado=="esperando":
		#print("volar")
		if enzona == false:
			estado = "volando"
			$AnimationPlayer.play("lanza")
			if creadotro == false:
				crearbloque()
		else:
			if(encima):
				var operatoria = Global.operatoria
				if bloquesumado != null:
					print (str(numero) + " " + operatoria + " " + str(bloquesumado.numero) )
					if operatoria == "+":
						bloquesumado.sumar(numero)
					elif operatoria == "-":
						if(bloquesumado.numero > numero):
							bloquesumado.numero =  bloquesumado.numero - numero
						else:
							bloquesumado.numero =  numero - bloquesumado.numero
						bloquesumado.update_num()
						#bloquesumado.restar(numero)
					destroy()
				else:
					position = posini
			else:
				position = posini
			
			
func crearbloque():
	#print ("Crear otro " + str(posini) )
	var otroBloque = load("res://Objects/ArrasBloque.tscn").instance()
	get_parent().call_deferred("add_child",otroBloque)
	otroBloque.posini = posini
	otroBloque.position = Vector2( posini.x , posini.y + abajonuevobloque)
	
	print ("mis posicion inicial Y= " + str(posini.y) +  " bloque  en Y= " + str(otroBloque.position.y) + " su posini = " + str (otroBloque.posini.y))
	
	if numero == 1:
		otroBloque.numero = 1
	else:
		otroBloque.resetbloque()
		
	otroBloque.numerodebloque = numerodebloque
	
	if controlpath != "":
		otroBloque.controlpath = controlpath
		otroBloque.getControl()
		
		match numerodebloque:
			1 : 
				print("crear bloque 1")
				control.bloque1 = otroBloque
			2 : 
				print("crear bloque 3")
				control.bloque2 = otroBloque
			3:
				print("crear bloque 4")
				control.bloque3 = otroBloque
			
	creadotro = true
	otroBloque.creadotro = false
	otroBloque.estado = "subiendo"
	otroBloque.target_y = posini.y
	otroBloque.callSetIniY_Timer()
	otroBloque.update_num()
	
func resetbloque():
	numero = randi()% 12 + 2
	update_num()


func _on_Area2D_body_entered(body):
	if body.is_in_group('num_block') and body != self:
		if body.estado == "esperando":
			print("encima de otro bloque")
			bloquesumado = body
			encima = true
			
			
	elif body.is_in_group('block_destructor'):
		#creadotro = true
		#print("sali de la pantalla y no toque nada")
		if Global.score > 0:
			Global.score-=10
		destroy()

func _on_Area2D_body_exited(body):
	if body.is_in_group('num_block'):
			print("sali del otro bloque")
			bloquesumado = null
			encima = false

#func _on_Area2D_area_entered(area):

func callSetIniY_Timer():
	print("LLamar timer")
	$SetIniY.start()

func _on_SetIniY_timeout():
	print("timer de  pos Ini_Y")
	posini.y = target_y
