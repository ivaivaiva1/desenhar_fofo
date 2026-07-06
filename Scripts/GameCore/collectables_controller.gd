extends Node2D
class_name CollectablesController

@onready var level_manager: LevelManager = get_tree().current_scene as LevelManager
var level_collectables: Array[Collectable] = []
var level_bubblegums: Array[Bubblegum] = []


func _ready() -> void:
	find_collectables(self)


func find_collectables(node: Node) -> void:
	for child in node.get_children():
		if child is Collectable:
			level_collectables.append(child)
		if child is Bubblegum:
			level_bubblegums.append(child)
		find_collectables(child)


func restore_collectables():
	await get_tree().process_frame
	for collectable in level_collectables:
		collectable.make_unpicked()
	for bubblegum in level_bubblegums:
		bubblegum.bubble_reset()


func check_if_cleared():
	var finish_level: bool = true
	for collectable in level_collectables:
		if !collectable.is_picked:
			finish_level = false
	if finish_level: level_manager.pass_level()
