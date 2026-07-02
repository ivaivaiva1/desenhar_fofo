extends Node2D

@export var floating_object: Node2D 
@onready var start_y: float = floating_object.position.y

@export var float_height: float = 5
@export var float_duration: float = 1
@export var random_duration_percent: float = 30

func _ready() -> void:
	var unique_duration = randf_range(
		float_duration / (1 - (random_duration_percent / 100)),
		float_duration * (1 + (random_duration_percent / 100))
	)
	do_floating(unique_duration)


func do_floating(unique_duration: float):
	var tween := create_tween()
	tween.set_loops()
	
	tween.tween_property(
		floating_object,
		"position:y",
		start_y - float_height,
		unique_duration
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	tween.tween_property(
		floating_object,
		"position:y",
		start_y,
		unique_duration
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
