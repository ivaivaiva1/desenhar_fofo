extends Node2D
class_name LevelManager

@export var is_testing: bool = false
@export var current_world: GameWorlds.WORLDS 
var next_level = preload("res://Scenes/collectable.tscn")

@onready var line_controller: LineController = %line_controller
@onready var collectables_controller: CollectablesController = %collectables_controller
@onready var state_label: RichTextLabel = $state_label

var player_scene: PackedScene = preload("uid://cre6fiyfcf35x")
@onready var player_pos: Marker2D = %player_spawner

var current_state: GAME_STATE = GAME_STATE.DRAWNING
var rolling_bob: Player


func _ready() -> void:
	spawn_enviorement()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_select"):
		get_tree().reload_current_scene()
	
	if current_state == GAME_STATE.ROLLING:
		if Input.is_action_just_pressed("ui_accept"):
			start_drawning()
			return
	
	if current_state == GAME_STATE.DRAWNING:
		if Input.is_action_just_pressed("ui_accept"):
				start_rolling()
				return


func start_drawning():
	current_state = GAME_STATE.DRAWNING
	rolling_bob.auto_destroy()
	collectables_controller.restore_collectables()
	player_pos.visible = true
	state_label.text = ("PRESS START TO PLAY")


func start_rolling():
	line_controller.finish_line()
	current_state = GAME_STATE.ROLLING
	spawn_bob()
	player_pos.visible = false
	state_label.text = ("PRESS START TO STOP")


func spawn_bob():
	var bob_instance = player_scene.instantiate()
	get_tree().current_scene.add_child(bob_instance)
	bob_instance.global_position = player_pos.global_position
	rolling_bob = bob_instance as Player
	rolling_bob.level_manager = self as LevelManager


enum GAME_STATE{
	DRAWNING,
	ROLLING
}


func pass_level():
	if is_testing:
		start_drawning()
		return
	get_tree().change_scene_to_packed(next_level)


var space_enviorement: PackedScene = preload("uid://cpgoaknm65vp5")
func spawn_enviorement():
	var target_enviorement: PackedScene
	match current_world:
		GameWorlds.WORLDS.SPACE:
			target_enviorement = space_enviorement
	var enviorement_instance:= target_enviorement.instantiate()
	get_tree().current_scene.add_child(enviorement_instance)
	enviorement_instance.global_position = Vector2.ZERO
