extends Node2D
class_name Collectable

var is_picked: bool = false
@onready var sprite: Sprite2D = %Sprite


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player"):
		make_picked()


func make_picked():
	if is_picked: return
	is_picked = true
	sprite.visible = false


func make_unpicked():
	if !is_picked: return
	is_picked = false
	sprite.visible = true
