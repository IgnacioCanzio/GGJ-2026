extends Node

@export var bodies_path: String = "res://items/bodies/test/"
var available_bodies: Array[Body] = []
var selected_body: Body

# --- Lógica de Enfermedades ---
var all_diseases: Array[String] = ["Gripe", "Photophobia", "Paranoia"] # Añade aquí tus nombres
var disease_descriptions: Dictionary = {
	"Gripe": "Produce mucho frío y sensibilidad a la humedad.",
	"Photophobia": "Marcada sensibilidad a la luz y sonido.",
	"Paranoia": "Interfiere con las señales cerebrales y se ve repelido por el cuero."
}

var current_disease_index: int = 0

func select_and_remove_body(body:Body):
	selected_body = body
	available_bodies.erase(body)

func confirm_selection():
	if selected_body:
		available_bodies.erase(selected_body) #

func _ready():
	load_bodies_from_folder(bodies_path)
	all_diseases.shuffle()

func load_bodies_from_folder(path: String):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir():
				# Al exportar, los archivos pueden terminar en .tres.remap
				if file_name.ends_with(".tres") or file_name.ends_with(".res") or file_name.get_extension() == "remap":
					# Limpiamos el ".remap" para que load() encuentre el recurso real
					var clean_path = path + file_name.replace(".remap", "")
					var body_res = load(clean_path)
					if body_res is Body:
						available_bodies.append(body_res)
			file_name = dir.get_next()
		dir.list_dir_end()

func get_current_disease() -> String:
	if current_disease_index < all_diseases.size():
		return all_diseases[current_disease_index]
	return ""

func get_current_description() -> String:
	return disease_descriptions.get(get_current_disease(), "Sin descripción")

func next_turn(success: bool):
	if success:
		current_disease_index += 1
	if current_disease_index >= all_diseases.size():
		print("¡VICTORIA! Todas las enfermedades curadas.")
		# get_tree().change_scene_to_file("res://scenes/victory_screen.tscn")
	elif available_bodies.is_empty():
		print("¡DERROTA! No quedan personajes y hay enfermedades pendientes.")
		# get_tree().change_scene_to_file("res://scenes/game_over.tscn")
