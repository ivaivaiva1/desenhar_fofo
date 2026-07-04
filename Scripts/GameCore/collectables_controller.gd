extends Node2D
class_name CollectablesController

@onready var level_manager: LevelManager = get_tree().current_scene as LevelManager
var level_collectables: Array[Collectable] = []


func _ready() -> void:
	for child in get_children():
		if child is Collectable:
			level_collectables.append(child)


func restore_collectables():
	for collectable in level_collectables:
		collectable.make_unpicked()


func check_if_cleared():
	var finish_level: bool = true
	for collectable in level_collectables:
		if !collectable.is_picked:
			finish_level = false
	if finish_level: level_manager.pass_level()
