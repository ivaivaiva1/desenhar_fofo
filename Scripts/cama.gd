extends Node2D
class_name Cama

@onready var collectables_controller: CollectablesController = get_parent()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player"):
		collectables_controller.check_if_cleared()
