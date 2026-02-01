extends Control

@export var gameplay_scene: PackedScene # 
@onready var grid: GridContainer = $MainLayout/SelectionGrid
@onready var confirm_button: Button = $MainLayout/ConfirmButton

var temp_selection: Body = null # 

func _ready():
	# Configuración de diseño por código para asegurar que ocupe espacio
	anchor_right = 1.0
	anchor_bottom = 1.0
	
	if confirm_button:
		confirm_button.disabled = true # 
		confirm_button.text = "Selecciona un personaje"
		if not confirm_button.pressed.is_connected(_on_confirm_pressed):
			confirm_button.pressed.connect(_on_confirm_pressed) # 
	
	setup_selection_grid() # 

func setup_selection_grid():
	for child in grid.get_children():
		child.queue_free() # 
	
	# Ajustes del Grid para estética 
	grid.columns = 5 
	grid.add_theme_constant_override("h_separation", 40)
	grid.add_theme_constant_override("v_separation", 40)
	
	for body in GameManager.available_bodies: # [cite: 8, 9]
		var btn = TextureButton.new()
		
		btn.texture_normal = body.textureIcon # [cite: 7, 8]
		btn.custom_minimum_size = Vector2(280, 280) # Aumentado para visibilidad 
		btn.ignore_texture_size = true
		btn.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED # 
		btn.pivot_offset = btn.custom_minimum_size / 2 # Para que la escala crezca desde el centro
		
		btn.modulate = Color(0.5, 0.5, 0.5) # 
		btn.pressed.connect(func(): _on_body_preselected(body, btn)) # 
		
		grid.add_child(btn)

func _on_body_preselected(body: Body, selected_btn: TextureButton):
	temp_selection = body # 
	confirm_button.disabled = false # 
	confirm_button.text = "Confirmar selección de: " + body.name
	
	for btn in grid.get_children():
		btn.modulate = Color(0.4, 0.4, 0.4) # 
		var t_reset = create_tween()
		t_reset.tween_property(btn, "scale", Vector2(1.0, 1.0), 0.1) # 
	
	selected_btn.modulate = Color(1.2, 1.2, 1.2) # Brillo para resaltar 
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(selected_btn, "scale", Vector2(1.15, 1.15), 0.2) # 

func _on_confirm_pressed():
	if temp_selection:
		GameManager.select_and_remove_body(temp_selection) # Lo quita de la lista global
		get_tree().change_scene_to_packed(gameplay_scene)
