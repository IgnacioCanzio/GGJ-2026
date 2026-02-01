extends Panel

@export var imagen_1: TextureRect
@export var imagen_2: TextureRect
@export var velocidad_fade: float = 0.3

# Estado 0: Imagen 1 visible
# Estado 1: Imagen 2 visible
# Estado 2: Todo oculto
var _estado_actual: int = 0

func _ready() -> void:
	# Estado inicial: Imagen 1 visible, Imagen 2 oculta
	if imagen_1 and imagen_2:
		imagen_1.self_modulate.a = 1.0
		imagen_2.self_modulate.a = 0.0
		self.visible = true

func avanzar_paso() -> void:
	var tween = create_tween().set_parallel(true)
	
	if _estado_actual == 0:
		# Pasar de Imagen 1 a Imagen 2
		tween.tween_property(imagen_1, "self_modulate:a", 0.0, velocidad_fade)
		tween.tween_property(imagen_2, "self_modulate:a", 1.0, velocidad_fade)
		_estado_actual = 1
		
	elif _estado_actual == 1:
		# Desaparecer el zócalo completo
		var tween_out = create_tween()
		tween_out.tween_property(self, "modulate:a", 0.0, velocidad_fade)
		tween_out.finished.connect(func(): self.visible = false)
		_estado_actual = 2

# Esta función la llamaremos desde el botón
func _on_texture_button_pressed() -> void:
	avanzar_paso()

func _on_texture_rect_2_pressed() -> void:
	pass # avanzar_paso()
