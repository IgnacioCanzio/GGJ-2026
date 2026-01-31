extends Node

@export var item_list: Array[Item]

@onready var sprite_eyes = $CharacterView/CharacterCointainer/eyes_slot
@onready var sprite_ears = $CharacterView/CharacterCointainer/ears_slot
@onready var sprite_nose_mouth = $CharacterView/CharacterCointainer/noseMouth_slot
@onready var sprite_hat = $CharacterView/CharacterCointainer/hat_slot
@onready var body_base = $CharacterView/CharacterCointainer/body_base

@onready var texture_background = $Background
@export var success_background:Background
@export var next_scene: PackedScene

var selected_body: Body
var actual_disease: String
var actual_outfit: Dictionary = {
	"eyes": null,
	"mouth nose": null,
	"ears": null,
	"hat": null
}

var items_per_category: Dictionary = {
	"eyes": [],
	"hat": [],
	"mouth nose": [],
	"ears": []
}

var actual_index: Dictionary = {
	"eyes": 0,
	"hat": 0,
	"mouth nose": 0,
	"ears": 0
}


func equip_item(new_item: Item):
	actual_outfit[new_item.category] = new_item
	match new_item.category:
		"eyes": sprite_eyes.texture = new_item.texture
		"hat" : sprite_hat.texture = new_item.texture
		"mouth nose": sprite_nose_mouth.texture = new_item.texture
		"ears": sprite_ears.texture = new_item.texture

func calculate_total() -> int:
	var total = 0
	
	for categoria in actual_outfit:
		var item = actual_outfit[categoria]
		if item != null:
			var points = item.points_per_disease.get(actual_disease, 0)
			total += points
			
	print("Puntaje total para ", actual_disease, ": ", total)
	return total

func _on_ready_button_pressed():
	print("tocando boton")
	var final_result = calculate_total()
	show_result(final_result)

func show_result(value:int):
	if success_background:
		texture_background.texture = success_background.texture

"""func _ready() -> void:
	if selected_body:
		apply_body(selected_body)
	for item in item_list:
		if items_per_category.has(item.category):
			items_per_category[item.category].append(item)
	for category in items_per_category:
		if not items_per_category[category].is_empty():
			equip_item(items_per_category[category][0])"""

func rotate_item(category:String):
	var list = items_per_category[category]
	if list.is_empty(): return
	actual_index[category] = (actual_index[category] + 1) % list.size()

	var new_item = list[actual_index[category]]
	equip_item(new_item)



func _on_eares_texture_pressed(extra_arg_0: String) -> void:
	rotate_item(extra_arg_0)


func _on_eyes_texture_pressed(extra_arg_0: String) -> void:
	rotate_item(extra_arg_0)


func _on_nose_mouth_texture_pressed(extra_arg_0: String) -> void:
	rotate_item(extra_arg_0)


func _on_hat_texture_pressed(extra_arg_0: String) -> void:
	rotate_item(extra_arg_0)

func apply_body(body_item: Body):
	body_base.texture = body_item.texture
