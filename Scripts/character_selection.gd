extends Control

@export var gameplay_scene: PackedScene
@export_group("Diapositivas")
@export var diapositivas: Array[Texture2D] = []  # Arrastra tus 2 imágenes aquí
@onready var sfx_player = $SfxPlayer
@onready var music_player = $MusicPlayer
@onready var display_imagen = $TextureRect  # Asume que existe en la escena
@onready var boton_siguiente = $TextureRect/Button  # Asume que existe en la escena
@export var sound_click: AudioStreamMP3
@export var music_track: AudioStreamWAV
@export var secret_body_id: String = "7"

var indice_actual: int = 0

func _ready():
	if music_track and music_player:
		music_player.volume_db = -10.0
		music_player.stream = music_track
		music_player.play()
	
	# Inicializar diapositivas si existen
	if diapositivas.size() > 0:
		display_imagen.texture = diapositivas[0]
		_actualizar_diapositiva(0)
	else:
		_mostrar_seleccion()
	
	boton_siguiente.pressed.connect(_on_boton_siguiente_pressed)
	_actualizar_disponibilidad_botones()

func _on_boton_siguiente_pressed() -> void:
	indice_actual += 1
	
	if indice_actual < diapositivas.size():
		display_imagen.texture = diapositivas[indice_actual]
		_actualizar_diapositiva(indice_actual)
	else:
		_mostrar_seleccion()

func _actualizar_diapositiva(indice: int) -> void:
	# Las diapositivas están visibles, Control visible pero no clickeable
	display_imagen.visible = true
	boton_siguiente.visible = true
	$Control.visible = true
	$Control.mouse_filter = Control.MOUSE_FILTER_IGNORE  # No bloquea clicks
	display_imagen.mouse_filter = Control.MOUSE_FILTER_STOP
	display_imagen.z_index = 100  # Diapositivas encima de todo

func _mostrar_seleccion() -> void:
	# Ocultar diapositivas, mostrar selección de personajes (clickeable)
	display_imagen.visible = false
	boton_siguiente.visible = false
	display_imagen.z_index = 0  # Restaurar z_index
	$Control.visible = true
	$Control.mouse_filter = Control.MOUSE_FILTER_STOP  # Permitir clicks
	_actualizar_disponibilidad_botones()

func _actualizar_disponibilidad_botones():
	# Contamos personajes normales restantes en el GameManager
	var normales_restantes = 0
	for b in GameManager.available_bodies:
		if b.name != secret_body_id:
			normales_restantes += 1
	
	for btn in $Control.get_children():
		if btn is TextureButton:
			var sensor = btn.get_node_or_null("ColorRect")
			if sensor:
				var body_id = sensor.body_name_id
				
				# LÓGICA PARA EL PERSONAJE SECRETO
				if body_id == secret_body_id:
					btn.show() # Siempre visible como pediste
					
					if normales_restantes == 0:
						btn.disabled = false
						btn.modulate = Color(1, 1, 1) # Color normal
					else:
						btn.disabled = true
						btn.modulate = Color(0.3, 0.3, 0.3) # Se ve oscuro/bloqueado
				
				# LÓGICA PARA PERSONAJES NORMALES
				else:
					var disponible = false
					for b in GameManager.available_bodies:
						if b.name == body_id:
							disponible = true
							break
					
					if disponible:
						btn.show()
						btn.disabled = false
					else:
						btn.hide() # Los normales sí se ocultan al agotarse

func _on_personaje_seleccionado_directo(body_id: String):
	var selected_resource: Body = null
	
	# Buscar el recurso en la lista de disponibles
	for b in GameManager.available_bodies:
		if b.name == body_id:
			selected_resource = b
			break
	
	if selected_resource:
		play_sfx()
		# 1. Seteamos el cuerpo en el GameManager y lo quitamos de la lista
		GameManager.select_and_remove_body(selected_resource)
		
		# 2. Cambio de escena inmediato
		if gameplay_scene:
			get_tree().change_scene_to_packed(gameplay_scene)
		else:
			print("Error: No asignaste la escena de juego en el Inspector")

func play_sfx():
	if sfx_player and sound_click:
		sfx_player.stream = sound_click
		sfx_player.play()
