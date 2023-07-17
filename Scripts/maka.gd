extends Node2D

var herramienta = preload("res://Objects/Bonus.tscn")
var herramienta1 = preload("res://Objects/Bonus1.tscn")
var mov = false
export var speed: int = 200
var origen
var crea = true
var addtowait = 1

export (NodePath) var playerpath
onready var player = get_node(playerpath)
# Called when the node enters the scene tree for the first time.
func _ready():
	origen = position
	$Timer.wait_time = rand_range(4,7) + addtowait
	$Timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if mov:
		position.x += speed*delta


func _on_Timer_timeout():
	#if not Global.extremo:
	if Global.menu_inicio:
		print("llamar la Makita en Menu")
		print("")
		mov = true
		$meaw.play()
		$Stop.start()
		
	else:
		if player.vida < 99:
			print("llamar la Makita en juego")
			mov = true
			$meaw.play()
			$Stop.start()
		else:
			print("llamar la Makita pero tengo toda la vida")
			$Timer.wait_time = rand_range(4,8)
			$Timer.start()

func _on_Stop_timeout():
	mov = false
	position = origen
	if Global.menu_inicio:
		addtowait = 1
	else:
		addtowait += rand_range(4,6)
	$Timer.wait_time = rand_range(5,12) + addtowait
	$Timer.start()


func _on_Area2D_input_event(_viewport, event, _shape_idx):
	if not Global.extremo:
		if event is InputEventMouseButton:
			if event.button_index == BUTTON_LEFT and event.pressed:
				creaTool()
		elif event is InputEventScreenTouch and event.pressed:
			creaTool()


func creaTool():
	if crea:
		$TimerHerra.wait_time = rand_range(0.2,0.5)
		$TimerHerra.start()
		crea = false
		var tools
		var rando = randi() % 10
		print(rando)
		if 2>rando:
			tools = herramienta.instance()
		else:
			tools = herramienta1.instance()
		get_parent().add_child(tools)
		tools.position = position


func _on_TimerHerra_timeout():
	crea = true
