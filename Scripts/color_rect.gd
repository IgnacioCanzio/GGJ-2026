extends ColorRect

@export var color_brillo: Color = Color(1.5, 1.5, 1.5, 1.0)
@export var color_normal: Color = Color(1.0, 1.0, 1.0, 1.0)

# Escribe aquí el nombre exacto del Recurso Body (ej: "Gordo", "Flaco")
@export var body_name_id: String = "" 

@onready var personaje: TextureButton = get_parent()
@onready var menu_principal = get_tree().current_scene 

func _ready() -> void:
	self.modulate.a = 0 
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	gui_input.connect(_on_gui_input)

func _on_mouse_entered() -> void:
	personaje.z_index = 10
	create_tween().tween_property(personaje, "self_modulate", color_brillo, 0.1)

func _on_mouse_exited() -> void:
	personaje.z_index = 0
	create_tween().tween_property(personaje, "self_modulate", color_normal, 0.1)

func _on_gui_input(event: InputEvent) -> void:
	# Verificamos si el botón padre (personaje) está deshabilitado
	if personaje.disabled:
		return # Ignora el clic si está bloqueado

	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if menu_principal.has_method("_on_personaje_seleccionado_directo"):
			menu_principal._on_personaje_seleccionado_directo(body_name_id)
