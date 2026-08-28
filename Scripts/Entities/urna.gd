extends Node2D

@onready var collectables_controller: CollectablesController = get_parent()
var little_bobs: Array[LittlePlayer] = []
var can_pass_level: bool = false
@onready var timer: Timer = %Timer


func _on_timer_timeout() -> void:
	if can_pass_level:
		collectables_controller.check_if_cleared()
		timer.start()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player"):
		var area_parent = area.get_parent()
		if area_parent is LittlePlayer:
			little_bobs.append(area_parent)
			if little_bobs.size() > 7:
				can_pass_level = true
				collectables_controller.check_if_cleared()
				if timer.is_stopped():
					timer.start()


func _on_area_2d_area_exited(area: Area2D) -> void:
	var exited_object := area.get_parent()
	if exited_object is LittlePlayer:
		for bobzinho in little_bobs:
			if exited_object == bobzinho:
				little_bobs.erase(bobzinho)
		if !little_bobs.size() > 7:
				can_pass_level = false
