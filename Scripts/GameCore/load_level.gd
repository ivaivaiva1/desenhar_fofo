extends Node2D
class_name LoadLevel

@onready var level_manager: LevelManager = get_parent()
@export var current_world: CurrentLevel.WORLDS 
@export var level: int

var level_instance: Level 
var enviorement_instance: Node2D
signal world_is_changing


func _ready() -> void:
	add_to_group("WorldIsChangingEmmiter")
	CurrentLevel.current_level = level
	CurrentLevel.current_world = current_world
	do_load_level()
	spawn_enviorement()


func do_load_level(level_id: int = 0, target_world: CurrentLevel.WORLDS = CurrentLevel.WORLDS.LOBBY):
	if level_id == 0:
		level = CurrentLevel.current_level
		CurrentLevel.current_world = current_world
	else:
		if enviorement_instance != null:
			enviorement_instance.queue_free()
			enviorement_instance = null
		level = level_id
		CurrentLevel.current_level = level
		CurrentLevel.current_world = target_world
		current_world = target_world
		spawn_enviorement()
		world_is_changing.emit()
	spawn_level()


var lobby_path: String = "res://Levels/Lobby/"
var candy_path: String = "res://Levels/Candy/"
var space_path: String = "res://Levels/Space/"
func spawn_level():
	var folder_path: String
	var world_offset_path: String
	var archive_type: String = ".tscn"
	
	var pré_level_path: String
	if level < 10:
		pré_level_path = "level0"
	else:
		pré_level_path = "level"
	
	match current_world:
		CurrentLevel.WORLDS.LOBBY:
			folder_path = lobby_path
			world_offset_path = "lobby"
		CurrentLevel.WORLDS.CANDY:
			folder_path = candy_path
			world_offset_path = "candy"
		CurrentLevel.WORLDS.SPACE:
			folder_path = space_path
			world_offset_path = "space"
	
	
	var level_path: String = folder_path + pré_level_path + str(level) + "_" + world_offset_path + archive_type
	var packed_level: PackedScene = load(level_path)
	if packed_level == null:
		next_world()
		return
	level_instance = packed_level.instantiate()
	level_manager.add_child.call_deferred(level_instance)
	level_instance.global_position = Vector2.ZERO
	level_instance.start(level_manager)

func next_world():
	current_world = CurrentLevel.WORLDS.SPACE
	CurrentLevel.current_level = 1
	if enviorement_instance != null:
		enviorement_instance.queue_free()
		enviorement_instance = null
	spawn_enviorement()
	do_load_level()
	world_is_changing.emit()

var candy_enviorement: PackedScene = preload("uid://bjiygpavx67dp")
var space_enviorement: PackedScene = preload("uid://cpgoaknm65vp5")
func spawn_enviorement():
	var target_enviorement: PackedScene
	match current_world:
		CurrentLevel.WORLDS.CANDY:
			target_enviorement = candy_enviorement
		CurrentLevel.WORLDS.SPACE:
			target_enviorement = space_enviorement
	if target_enviorement == null: return
	enviorement_instance = target_enviorement.instantiate()
	get_tree().current_scene.add_child.call_deferred(enviorement_instance)
	enviorement_instance.global_position = Vector2.ZERO


func free_level():
	level_instance.queue_free()
	level_instance = null
