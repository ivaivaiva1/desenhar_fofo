extends Node2D
class_name Level

@export var little_bobs: bool = false
@export var bob_count: int = 0
var bobzinho_controller: BobzinhoController 


func start(level_manager: LevelManager):
	level_manager.player_pos = %player_spawner
	level_manager.collectables_controller = %collectables_controller
	bobzinho_controller = %bobzinho_controller
	if bobzinho_controller: bobzinho_controller.level_manager = level_manager
