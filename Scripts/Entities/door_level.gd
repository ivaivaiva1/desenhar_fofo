extends Node2D

@onready var level_manager: LevelManager = get_parent().get_parent() as LevelManager
@onready var load_level: LoadLevel = level_manager.load_level
@export var current_world: CurrentLevel.WORLDS 
@export var level: int
@onready var level_label: RichTextLabel = %LevelLabel
@onready var progress_bar: ProgressBar = %ProgressBar
var has_player: bool = false
var door_cooldown: float = 2
@onready var door_timer: float = door_cooldown


func _ready() -> void:
	level_label.text = str(level)
	update_progress_bar()


func _process(delta: float) -> void:
	if has_player:
		if door_timer > 0:
			door_timer -= delta
			update_progress_bar()
		else:
			start_level()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player"): 
		door_timer = door_cooldown
		has_player = true


func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("Player"): 
		has_player = false
		door_timer = door_cooldown
		update_progress_bar()


func start_level():
	level_manager.pass_level(false)
	load_level.do_load_level(level, current_world)


func update_progress_bar():
	progress_bar.value = (1.0 - (door_timer / door_cooldown)) * 100.0
