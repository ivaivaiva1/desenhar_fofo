extends Node2D
class_name Pudim
@export var pudim_force: float 

@onready var pudim_sprite: Sprite2D = %pudim_sprite
@onready var original_scale: Vector2 = pudim_sprite.scale
var pump_tween: Tween 
func pump_pudim():
	if pump_tween: pump_tween.kill()
	pump_tween = create_tween()
	
	pump_tween.tween_property(
		pudim_sprite,
		"scale",
		Vector2(original_scale.x * 1.1, original_scale.y * 1.15),
		0.1
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	pump_tween.tween_property(
		pudim_sprite,
		"scale",
		Vector2(original_scale.x * 0.93, original_scale.y * 0.9),
		0.095
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	pump_tween.tween_property(
		pudim_sprite,
		"scale",
		Vector2(original_scale.x * 1.07, original_scale.y * 1.11),
		0.088
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	pump_tween.tween_property(
		pudim_sprite,
		"scale",
		Vector2(original_scale.x * 0.95, original_scale.y * 0.93),
		0.077
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	pump_tween.tween_property(
		pudim_sprite,
		"scale",
		Vector2(original_scale.x * 1.04, original_scale.y * 1.07),
		0.064
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	pump_tween.tween_property(
		pudim_sprite,
		"scale",
		original_scale,
		0.048
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
