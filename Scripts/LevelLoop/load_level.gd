extends Node2D
class_name LoadLevel

@onready var level_manager: LevelManager = get_parent()
@export var current_world: CurrentLevel.WORLDS 
@export var level: int

var level_instance = Level 


func _ready() -> void:
	CurrentLevel.current_level = level
	do_load_level()


func do_load_level():
	level = CurrentLevel.current_level
	spawn_level()
	spawn_enviorement()


var candy_path: String = "res://Levels/Candy/"
var space_path: String = "res://Levels/Space/"
func spawn_level():
	var folder_path: String
	var world_offset_path: String
	var archive_type: String = ".tscn"
	match current_world:
		CurrentLevel.WORLDS.CANDY:
			folder_path = candy_path
			world_offset_path = "candy"
		CurrentLevel.WORLDS.SPACE:
			folder_path = space_path
			world_offset_path = "space"
	var pré_level_path: String
	if level < 10:
		pré_level_path = "level0"
	else:
		pré_level_path = "level"
	
	var level_path: String = folder_path + pré_level_path + str(level) + "_" + world_offset_path + archive_type
	var packed_level: PackedScene = load(level_path)
	level_instance = packed_level.instantiate()
	level_manager.add_child.call_deferred(level_instance)
	level_instance.global_position = Vector2.ZERO
	level_instance.start(level_manager)



var space_enviorement: PackedScene = preload("uid://cpgoaknm65vp5")
func spawn_enviorement():
	var target_enviorement: PackedScene
	match current_world:
		CurrentLevel.WORLDS.SPACE:
			target_enviorement = space_enviorement
	var enviorement_instance = target_enviorement.instantiate()
	level_instance.add_child.call_deferred(enviorement_instance)
	enviorement_instance.global_position = Vector2.ZERO


func free_level():
	level_instance.queue_free()
	level_instance = null
