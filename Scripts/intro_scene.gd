extends Control

@export_group("Contenido")
@export var diapositivas: Array[Texture2D] = [] # Arrastra tus imágenes aquí
@export_file("*.tscn") var siguiente_escena: String = "res://Scenes/menu_seleccion.tscn"

@onready var display_imagen = $TextureRect

var indice_actual: int = 0

func _ready() -> void:
	# 1. Configurar la primera imagen
	if diapositivas.size() > 0:
		display_imagen.texture = diapositivas[0]

func _on_next_button_pressed() -> void:
	indice_actual += 1
	
	if indice_actual < diapositivas.size():
		# Cambiar a la siguiente imagen
		display_imagen.texture = diapositivas[indice_actual]
	else:
		# Si ya no hay más imágenes, vamos a la selección de personaje
		get_tree().change_scene_to_file(siguiente_escena)
