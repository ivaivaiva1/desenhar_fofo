extends Node2D
class_name Level

func start(level_manager: LevelManager):
	level_manager.player_pos = %player_spawner
	level_manager.collectables_controller = %collectables_controller
