extends Node2D
class_name Cama

@export var entity_type: SkinPicker.ENTITY_TYPE
@onready var collectables_controller: CollectablesController = get_parent()
@onready var sprite: Sprite2D = %Sprite


func _ready() -> void:
	SkinPicker.change_skin(entity_type, sprite)


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player"):
		collectables_controller.check_if_cleared()
