extends Node2D

var travel_object: Node2D
var start_position: Vector2

var patrol_point: Vector2

@export var target_object: Marker2D
@export var travel_time: float = 2.0

@export var transition: Tween.TransitionType = Tween.TRANS_SINE
@export var ease_type: Tween.EaseType = Tween.EASE_IN_OUT


func _ready() -> void:
	if target_object == null:
		return
	
	travel_object = get_parent()
	start_position = travel_object.global_position
	patrol_point = target_object.global_position
	
	do_patrol()


var tween_patrol: Tween

func do_patrol():
	tween_patrol = create_tween()
	tween_patrol.set_loops()
	
	tween_patrol.tween_property(
		travel_object,
		"global_position",
		patrol_point,
		travel_time / 2
	).set_trans(transition).set_ease(ease_type)
	
	tween_patrol.tween_property(
		travel_object,
		"global_position",
		start_position,
		travel_time / 2
	).set_trans(transition).set_ease(ease_type)
