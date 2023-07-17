extends Node

var volumen_general = 0.0
var volumen_musica = -5.6
var volumen_sfx = 5.0
var score = 0
var puntaje = {'Moneda': 0}
var vidas = 0
var salud = 5
var max_score = 0
var idiomas = TranslationServer.get_loaded_locales()
var idioma = idiomas.bsearch('en')
var perder = false
var continuaciones = 0
var costeContinue = 50
var extremo = false
var menu_inicio = true

var operatoria = "+"

var datos_partida = {
	volumen_general = 0.0,
	volumen_musica = 0.0,
	volumen_sfx = 0.0,
	max_score = 0,
	idioma = 0
}

var s = ResourceLoader.load("res://Scenes/Escena.tscn")
var sceneToGo

# Called when the node enters the scene tree for the first time.
func _ready():
	var path = Directory.new()
	idiomas.sort()
	if not path.dir_exists("user://saves"):
		#print('Creado')
		path.open("user://")
		path.make_dir("user://saves")
		guardar()
	else:
		#print('Cargado')
		cargar()
		if typeof(idioma) == TYPE_STRING:
			idioma = idiomas.bsearch('en')
		
	TranslationServer.set_locale(idiomas[idioma])
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), volumen_general)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music_bus"), volumen_musica)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX_bus"), volumen_sfx)
	
func guardar():
	var save = File.new()
	save.open("user://saves/data.save", File.WRITE)
	
	var datos_guardar = datos_partida
	
	datos_partida.volumen_general = volumen_general
	datos_partida.volumen_musica = volumen_musica
	datos_partida.volumen_sfx = volumen_sfx
	datos_partida.max_score = max_score
	datos_partida.idioma = 'en'#idioma
	TranslationServer.set_locale(idiomas[idioma])
	save.store_line(to_json(datos_guardar))
	
	save.close()
	
	
func cargar():
	var cargar = File.new()
	if cargar.file_exists("user://saves/data.save"):
		cargar.open("user://saves/data.save",File.READ)
		
		var datos_cargar = datos_partida
		datos_cargar = parse_json(cargar.get_line())
		
		cargar.close()
		
		#print(datos_cargar)
		
		max_score = datos_cargar.max_score
		idioma = datos_cargar.idioma
		volumen_general = datos_cargar.volumen_general
		volumen_musica = datos_cargar.volumen_musica
		volumen_sfx = datos_cargar.volumen_sfx
	else:
		print('error carga')


func cambioEscena():

	call_deferred("_deferred_goto_scene")


func cambioOtraEscena(name):
	print(" llendo hacia la esena " + str(name) )
	s = ResourceLoader.load("res://Scenes/" + name + ".tscn" )
	print(str(s))
	call_deferred("_deferred_goto_scene")
	
	
func _deferred_goto_scene():
	# It is now safe to remove the current scene
	var current_scene = get_tree().current_scene
	current_scene.free()
	
	# Instance the new scene.
	current_scene = s.instance()
	
	# Add it to the active scene, as child of root.
	get_tree().get_root().add_child(current_scene)
	
	# Optionally, to make it compatible with the SceneTree.change_scene() API.
	get_tree().set_current_scene(current_scene)
	
	
# warning-ignore:unused_argument
func _deferred_goto_another_scene(scenename):
	#print("Me voy a la escena " + scenename)
	
	var current_scene = get_tree().current_scene
	current_scene.free()
	
	current_scene = sceneToGo.instance()
	
	# Add it to the active scene, as child of root.
	get_tree().get_root().add_child(current_scene)
	
	# Optionally, to make it compatible with the SceneTree.change_scene() API.
	get_tree().set_current_scene(current_scene)

	
	

func customComparison(a, b):
	return hash(a)<hash(b)
