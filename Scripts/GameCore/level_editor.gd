extends Node2D

var save_path: String = "res://Levels/"

var player_spawner: Node2D
var cama: Cama
var collectables: Array[Collectable] = []


func _ready() -> void:
	for world in WORLD_NAMES:
		select_world.add_item(world)
	
	player_spawner = get_tree().get_first_node_in_group("PlayerSpawner") as Node2D
	cama = get_tree().get_first_node_in_group("Cama") as Cama
	for collectable in get_tree().get_nodes_in_group("Collectable"):
		collectables.append(collectable as Collectable)


func save_level(scene_world: String, level_name: String) -> void:
	var file_name := scene_world + "_level_" + level_name + ".json"
	
	var data := {
		"player_spawner": {
			"x": player_spawner.global_position.x,
			"y": player_spawner.global_position.y
		},
		"cama": {
			"x": cama.global_position.x,
			"y": cama.global_position.y
		},
		"collectables": []
	}
	
	for collectable in collectables:
		data["collectables"].append({
			"x": collectable.global_position.x,
			"y": collectable.global_position.y
		})
	
	var json := JSON.stringify(data, "\t")
	
	var file := FileAccess.open(save_path + file_name, FileAccess.WRITE)
	if file:
		file.store_string(json)
		file.close()
	else:
		push_error("Não foi possível salvar o level.")



const WORLD_NAMES := [
	"candy",
	"forest",
	"desert",
	"snow"
]


@onready var select_world: OptionButton = %select_world
@onready var level_name: LineEdit = %level_name


func _on_save_level_button_button_down() -> void:
	var world := select_world.get_item_text(select_world.selected)
	var level := level_name.text.strip_edges()
	
	if level.is_empty(): return
	
	save_level(world, level)
