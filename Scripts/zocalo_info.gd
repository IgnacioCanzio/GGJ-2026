extends Panel

@export var cuadro_imagen_1: TextureRect
@export var cuadro_imagen_2: TextureRect
@export var tiempo_espera: float = 3.0
@export var velocidad_transicion: float = 0.5

@onready var cronometro: Timer = $Timer

var _mostrando_primera: bool = true

func _ready() -> void:
	# Configuración del Timer
	cronometro.wait_time = tiempo_espera
	
	# Verificamos que los nodos estén asignados para evitar errores
	if cuadro_imagen_1 and cuadro_imagen_2:
		cuadro_imagen_1.self_modulate.a = 1.0
		cuadro_imagen_2.self_modulate.a = 0.0
		cronometro.timeout.connect(_on_timer_timeout)

func _on_timer_timeout() -> void:
	_intercambiar_imagenes()

func _intercambiar_imagenes() -> void:
	# Creamos un tween paralelo para que una aparezca mientras la otra desaparece
	var tween = create_tween().set_parallel(true)
	
	if _mostrando_primera:
		tween.tween_property(cuadro_imagen_1, "self_modulate:a", 0.0, velocidad_transicion)
		tween.tween_property(cuadro_imagen_2, "self_modulate:a", 1.0, velocidad_transicion)
	else:
		tween.tween_property(cuadro_imagen_2, "self_modulate:a", 0.0, velocidad_transicion)
		tween.tween_property(cuadro_imagen_1, "self_modulate:a", 1.0, velocidad_transicion)
	
	_mostrando_primera = !_mostrando_primera
