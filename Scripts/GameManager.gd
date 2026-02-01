extends Node

@export var available_bodies: Array[Body] = []

var selected_body:Body

func select_and_remove_body(body:Body):
	selected_body = body
	available_bodies.erase(body)

func confirm_selection():
	if selected_body:
		available_bodies.erase(selected_body) #

func _ready():
	load_bodies_from_folder("res://items/bodies/test/")

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
