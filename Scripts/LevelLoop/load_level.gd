extends Node2D

@onready var level_manager: LevelManager = get_parent()
@export var current_world: GameWorlds.WORLDS 
@export var level: String

func _ready() -> void:
	spawn_level()
	spawn_enviorement()



var candy_path: String = "res://Levels/Candy/"
var space_path: String = "res://Levels/Space/"
func spawn_level():
	var folder_path: String
	match current_world:
		GameWorlds.WORLDS.CANDY:
			folder_path = candy_path
		GameWorlds.WORLDS.SPACE:
			folder_path = space_path
	
	var level_path: String = folder_path + level
	var packed_level: PackedScene = load(level_path)
	var level_instance = packed_level.instantiate()
	level_manager.add_child.call_deferred(level_instance)
	level_instance.global_position = Vector2.ZERO
	var current_level: Level = level_instance as Level
	current_level.start(level_manager)



var space_enviorement: PackedScene = preload("uid://cpgoaknm65vp5")
func spawn_enviorement():
	var target_enviorement: PackedScene
	match current_world:
		GameWorlds.WORLDS.SPACE:
			target_enviorement = space_enviorement
	var enviorement_instance:= target_enviorement.instantiate()
	get_tree().current_scene.add_child.call_deferred(enviorement_instance)
	enviorement_instance.global_position = Vector2.ZERO
