extends Control

@export var seconds_to_wait: float = 5.0
@export var is_victory_screen: bool = false # Para diferenciar lógica si es necesario

func _ready() -> void:
	# Iniciamos el temporizador
	var timer = get_tree().create_timer(seconds_to_wait)
	timer.timeout.connect(_on_time_out)
	
	print("Mostrando pantalla final. Esperando: ", seconds_to_wait, " segundos.")

func _on_time_out() -> void:
	if is_victory_screen:
		# Si quieres que al ganar simplemente se cierre el juego
		get_tree().quit() 
	else:
		# Si perdió, quizás quieras enviarlo de vuelta al menú principal
		# o reiniciar todo el GameManager
		_reiniciar_juego()

func _reiniciar_juego() -> void:
	GameManager.reset_game() 
	get_tree().change_scene_to_file("res://Scenes/menu_seleccion.tscn")
