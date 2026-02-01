extends Node

@export var item_list: Array[Item] # 

# Referencias a los botones para cambiar sus iconos
@onready var button_eyes = $CategorySelection/EyesTexture # 
@onready var button_ears = $CategorySelection/EaresTexture # 
@onready var button_nose_mouth = $CategorySelection/NoseMouthTexture # 
@onready var button_hat = $CategorySelection/HatTexture # 

@onready var sprite_eyes = $CharacterView/CharacterCointainer/eyes_slot # 
@onready var sprite_ears = $CharacterView/CharacterCointainer/ears_slot # 
@onready var sprite_nose_mouth = $CharacterView/CharacterCointainer/noseMouth_slot # 
@onready var sprite_hat = $CharacterView/CharacterCointainer/hat_slot # 
@onready var body_base = $CharacterView/CharacterCointainer/body_base # 

@onready var texture_background = $Background # 

@export var success_background:BackgroundData # 
@export var next_scene: PackedScene # 

var selected_body: Body # 
var actual_disease: String = "Gripe" # 
var actual_outfit: Dictionary = {
	"eyes": null,
	"mouth nose": null,
	"ears": null,
	"hat": null
} # 

var items_per_category: Dictionary = {
	"eyes": [],
	"hat": [],
	"mouth nose": [],
	"ears": []
} # [cite: 3]

var actual_index: Dictionary = {
	"eyes": 0,
	"hat": 0,
	"mouth nose": 0,
	"ears": 0
} # 

func _ready() -> void:
	if GameManager.selected_body:
		apply_body(GameManager.selected_body)
	elif selected_body:
		apply_body(selected_body)
	
	if item_list.is_empty():
		print("ADVERTENCIA: La lista de items (item_list) está vacía en el Inspector.")
	
	for item in item_list:
		if items_per_category.has(item.category):
			items_per_category[item.category].append(item) # 
		else:
			print("Error: El item ", item.name, " tiene una categoría inválida: ", item.category)
	
	for category in items_per_category:
		if not items_per_category[category].is_empty():
			equip_item(items_per_category[category][0]) # 

func equip_item(new_item: Item):
	if new_item == null: return
	
	actual_outfit[new_item.category] = new_item # 
	
	# Actualizar Textura en el Personaje y el Icono en el Botón
	match new_item.category:
		"eyes":
			sprite_eyes.texture = new_item.texture # 
			if button_eyes: button_eyes.texture_normal = new_item.texture_icon
		"hat":
			sprite_hat.texture = new_item.texture # 
			if button_hat: button_hat.texture_normal = new_item.texture_icon
		"mouth nose":
			sprite_nose_mouth.texture = new_item.texture # 
			if button_nose_mouth: button_nose_mouth.texture_normal = new_item.texture_icon
		"ears":
			sprite_ears.texture = new_item.texture # 
			if button_ears: button_ears.texture_normal = new_item.texture_icon

func rotate_item(category: String):
	# Limpieza de seguridad: elimina comillas y espacios accidentales
	var clean_category = category.replace('"', '').strip_edges().to_lower()
	
	if not items_per_category.has(clean_category):
		print("ERROR: No existe la categoría '", clean_category, "' en el diccionario.")
		return

	var list = items_per_category[clean_category] # 
	if list.is_empty(): 
		print("ERROR: No hay items cargados para la categoría: ", clean_category)
		return # 
	
	actual_index[clean_category] = (actual_index[clean_category] + 1) % list.size() # 
	var new_item = list[actual_index[clean_category]] # 
	
	print("Rotando ", clean_category, " al item: ", new_item.name)
	equip_item(new_item) # 

func calculate_total() -> int:
	var total = 0
	for categoria in actual_outfit:
		var item = actual_outfit[categoria] # [cite: 4]
		if item != null: # [cite: 4]
			var points = item.points_per_disease.get(actual_disease, 0) # [cite: 4]
			total += points
	print("Puntaje total para ", actual_disease, ": ", total) # [cite: 4]
	return total # [cite: 4]

func show_result(value: int):
	if success_background and texture_background:
		texture_background.texture = success_background.texture # 
		print("Puntaje: ", value, " Cambiando de escena en 1.5 segundos") # 
		await get_tree().create_timer(1.5).timeout # 
		if next_scene:
			get_tree().change_scene_to_packed(next_scene) # 
		else:
			print("Error: No has asignado escena siguiente.") # 

func _on_ready_button_pressed():
	var final_result = calculate_total() # 
	show_result(final_result) # 

# Señales de los botones
func _on_eares_texture_pressed(extra_arg_0: String) -> void:
	print("Señal presionada: ears")
	rotate_item(extra_arg_0) # [cite: 2, 5]

func _on_eyes_texture_pressed(extra_arg_0: String) -> void:
	rotate_item(extra_arg_0) # 

func _on_nose_mouth_texture_pressed(extra_arg_0: String) -> void:
	rotate_item(extra_arg_0) # 

func _on_hat_texture_pressed(extra_arg_0: String) -> void:
	rotate_item(extra_arg_0) # 

func apply_body(body_item: Body):
	body_base.texture = body_item.textureSelection
