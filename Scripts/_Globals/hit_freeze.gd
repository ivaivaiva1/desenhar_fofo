extends Node

var freeze_tween: Tween

func freeze(time_scale: float = 0.5, duration: float = 0.1) -> void:
	if freeze_tween:
		freeze_tween.kill()
	
	Engine.time_scale = time_scale
	
	freeze_tween = create_tween()
	freeze_tween.set_ignore_time_scale(true)
	
	freeze_tween.tween_interval(duration)
	
	freeze_tween.tween_callback(func():
		Engine.time_scale = 1.0
		freeze_tween = null
	)
