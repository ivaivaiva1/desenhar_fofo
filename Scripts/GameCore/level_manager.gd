extends Node2D
class_name LevelManager

@export var is_testing: bool = false

@onready var line_controller: LineController = %line_controller
@onready var level_ui: LevelUI = %UI
@onready var line_rendering = get_node("line_rendering")
@onready var line_collider = get_node("line_collider")
@onready var load_level: LoadLevel = %load_level
@onready var state_label: RichTextLabel = $state_label
var collectables_controller: CollectablesController

var player_pos: Marker2D 
var player_scene: PackedScene = preload("uid://cre6fiyfcf35x")
var little_bob_scene: PackedScene = preload("uid://d0aen8rgrfni3")


var current_state: GAME_STATE = GAME_STATE.DRAWNING
var rolling_bob

signal clear_lines()


func _ready() -> void:
	CurrentLevel.level_manager = self
	MusicManager.play_instant(SoundsList.CANDY_WORLD)
	level_ui.level_manager = self
	level_ui.line_controller = line_controller
	clear_lines.connect(line_rendering.clear)
	clear_lines.connect(line_collider.clear)


func _process(_delta: float) -> void:
	if current_state == GAME_STATE.ROLLING:
		if Input.is_action_just_pressed("ui_cancel"):
			pass_level()
		if Input.is_action_just_pressed("ui_accept"):
			start_drawning()
			return
	
	if current_state == GAME_STATE.DRAWNING:
		if Input.is_action_just_pressed("ui_select"):
			clear_lines.emit()
		
		if Input.is_action_just_pressed("ui_accept"):
				start_rolling()
				return


func start_drawning():
	if current_state == GAME_STATE.DRAWNING: return
	current_state = GAME_STATE.DRAWNING
	if rolling_bob is Player: rolling_bob.auto_destroy()
	else:
		rolling_bob.clear()
	state_label.text = (" SPACE TO PLAY")
	if load_level.level_instance == null: return
	if collectables_controller != null:
		collectables_controller.restore_collectables()
	player_pos.visible = true
	level_ui.hide_rolling_ui()


func start_rolling():
	if current_state == GAME_STATE.ROLLING: return
	line_controller.finish_line()
	current_state = GAME_STATE.ROLLING
	if !load_level.level_instance.little_bobs:
		spawn_bob()
	else:
		spawn_little_bobs()
	player_pos.visible = false
	state_label.text = (" SPACE TO STOP")
	level_ui.hide_drawining_ui()


func spawn_bob():
	var bob_instance = player_scene.instantiate()
	get_tree().current_scene.add_child(bob_instance)
	bob_instance.global_position = player_pos.global_position
	rolling_bob = bob_instance as Player
	rolling_bob.current_level = load_level.level_instance
	rolling_bob.level_manager = self as LevelManager


func spawn_little_bobs():
	var little_bob_instance = little_bob_scene.instantiate()
	get_tree().current_scene.add_child(little_bob_instance)
	little_bob_instance.global_position = player_pos.global_position
	little_bob_instance.start(self, load_level.level_instance.bob_count, 400)
	rolling_bob = load_level.level_instance.bobzinho_controller


func pass_level(call_next_level: bool = true):
	SfxManager.play_sfx(SoundsList.DUPLICATE_SOUND)
	Engine.time_scale = 0.1
	await get_tree().create_timer(0.1).timeout
	Engine.time_scale = 1
	level_ui.hide_rolling_ui()
	if is_testing:
		start_drawning()
		return
	load_level.free_level()
	if current_state == GAME_STATE.ROLLING:
		start_drawning()
	clear_lines.emit()
	if !call_next_level: return
	CurrentLevel.current_level += 1
	load_level.do_load_level()


enum GAME_STATE{
	DRAWNING,
	ROLLING
}
