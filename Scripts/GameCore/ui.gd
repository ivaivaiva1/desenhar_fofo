extends Node2D
class_name LevelUI

var level_manager: LevelManager
var line_controller: LineController
@onready var drawning: Node2D = %Drawning
@onready var rolling: Node2D = %Rolling


func hide_drawining_ui():
	drawning.visible = false
	rolling.visible = true


func hide_rolling_ui():
	rolling.visible = false
	drawning.visible = true


func _on_play_button_button_down() -> void:
	level_manager.start_rolling()

func _on_pause_button_button_down() -> void:
	level_manager.start_drawning()

func _on_trash_button_button_down() -> void:
	level_manager.clear_lines.emit()


func _on_home_button_button_down() -> void:
	level_manager.pass_level(false)
	level_manager.load_level.do_load_level(1, CurrentLevel.WORLDS.LOBBY)
