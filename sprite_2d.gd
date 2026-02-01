extends AnimatedSprite2D

@export_group("Configuracion de Movimiento")
@export var valor_progreso: float = 40.0 
@export var meta: float = 50.0
@export var multiplicador_distancia: float = 40.0 
@export var velocidad_constante: float = 300.0

@export_group("Efectos de Muerte")
@export var tiempo_espera_en_suelo: float = 2.0
@export var tiempo_fundido_negro: float = 2.0

@export_group("Sonidos")
@export var sonido_caminata: AudioStream # Asigna aquí el sonido de pasos
@export var male_death: AudioStream     # Asigna aquí el sonido de muerte

@export_group("Escenas")
@export_file("*.tscn") var escena_ganar: String
@export_file("*.tscn") var escena_perder: String

# Necesitaremos un AudioStreamPlayer para los pasos que podamos detener
var sfx_caminata_player: AudioStreamPlayer

func _ready() -> void:
	# Configuramos el reproductor de pasos
	sfx_caminata_player = AudioStreamPlayer.new()
	add_child(sfx_caminata_player)
	sfx_caminata_player.stream = sonido_caminata
	
	valor_progreso = GameManager.current_score_progress
	_inicializar_secuencia()

func _inicializar_secuencia() -> void:
	if sprite_frames.has_animation("caminar"):
		play("caminar")
		# Iniciar sonido de caminata en bucle
		if sonido_caminata:
			sfx_caminata_player.play()
	
	await get_tree().create_timer(0.2).timeout
	_procesar_movimiento()

func _procesar_movimiento() -> void:
	var pos_inicio_x = global_position.x
	var destino_x: float
	
	if valor_progreso >= meta:
		destino_x = pos_inicio_x + 2100
	else:
		destino_x = pos_inicio_x + (valor_progreso * multiplicador_distancia)
	
	var distancia = abs(destino_x - pos_inicio_x)
	var tiempo_viaje = distancia / velocidad_constante
	
	var tween = create_tween()
	tween.tween_property(self, "global_position:x", destino_x, tiempo_viaje).set_trans(Tween.TRANS_LINEAR)
	tween.finished.connect(_al_finalizar_camino)

func _al_finalizar_camino() -> void:
	# Detenemos el sonido de caminata cuando deja de moverse
	if sfx_caminata_player.playing:
		sfx_caminata_player.stop()
	
	var resultado_exito = valor_progreso >= meta
	
	if resultado_exito:
		_procesar_cambio_de_estado(true)
	else:
		_ejecutar_muerte()

func _ejecutar_muerte() -> void:
	# Reproducir sonido de muerte masculino
	if male_death:
		var death_player = AudioStreamPlayer.new()
		add_child(death_player)
		death_player.stream = male_death
		death_player.play()
		# Se limpia solo al terminar el sonido
		death_player.finished.connect(death_player.queue_free)

	if sprite_frames.has_animation("muerte"):
		play("muerte") 
		await animation_finished 
		await get_tree().create_timer(tiempo_espera_en_suelo).timeout
		_oscurecer_pantalla()
	else:
		stop()
		_procesar_cambio_de_estado(false)

func _oscurecer_pantalla() -> void:
	var filtro = get_parent().get_node_or_null("FiltroOscuro")
	if filtro:
		var tween = create_tween()
		tween.tween_property(filtro, "color", Color.BLACK, tiempo_fundido_negro)
		tween.finished.connect(func(): _procesar_cambio_de_estado(false))
	else:
		_procesar_cambio_de_estado(false)

func _procesar_cambio_de_estado(exito: bool) -> void:
	var estado_actual = GameManager.next_turn(exito)
	
	match estado_actual:
		GameManager.GameState.VICTORY:
			_cambiar_escena(escena_ganar, 0.5)
		GameManager.GameState.GAME_OVER:
			_cambiar_escena(escena_perder, 0.5)
		GameManager.GameState.CONTINUE_NEXT, GameManager.GameState.CONTINUE_SAME:
			get_tree().change_scene_to_file("res://Scenes/CharacterSelection.tscn")

func _cambiar_escena(ruta: String, delay: float) -> void:
	if ruta == "" or ruta == null: return
	if delay > 0:
		await get_tree().create_timer(delay).timeout
	get_tree().change_scene_to_file(ruta)
