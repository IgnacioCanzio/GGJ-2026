extends Control

@export_group("Contenido")
@export var diapositivas: Array[Texture2D] = []
@export_file("*.tscn") var siguiente_escena: String = "res://Scenes/menu_seleccion.tscn"

@onready var display_imagen = $TextureRect
@onready var label_segunda = $Label

var indice_actual: int = 0

func _ready() -> void:
    if diapositivas.size() > 0:
        display_imagen.texture = diapositivas[0]
        _actualizar_label(0)

func _on_next_button_pressed() -> void:
    indice_actual += 1
    
    if indice_actual < diapositivas.size():
        display_imagen.texture = diapositivas[indice_actual]
        _actualizar_label(indice_actual)
    else:
        get_tree().change_scene_to_file(siguiente_escena)

func _actualizar_label(indice: int) -> void:
    if indice == 1:
        label_segunda.visible = true
        var descripcion = GameManager.get_current_description()
        label_segunda.text = descripcion
    else:
        label_segunda.visible = false