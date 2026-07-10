extends Node2D
class_name Clown

@onready var collectable: Collectable = get_parent() as Collectable
var start_hiding: bool = false
var hide_cooldown: float = 1
var hide_tween_timer: float = 2
@onready var hide_timer: float = hide_cooldown
@onready var sprite := %Sprite


func _process(delta: float) -> void:
	if CurrentLevel.level_manager.current_state != CurrentLevel.level_manager.GAME_STATE.ROLLING: return
	if collectable.can_be_picked:
		if hide_timer > 0:
			hide_timer -= delta
		else:
			if start_hiding: return 
			hide_clown()


var hide_tween: Tween
func hide_clown():
	if collectable.is_picked: return
	start_hiding = true 
	if hide_tween:
		hide_tween.kill()
		sprite.modulate.a = 1
	hide_tween = sprite.create_tween()
	hide_tween.set_trans(Tween.TRANS_SINE)
	hide_tween.set_ease(Tween.EASE_IN_OUT)
	hide_tween.tween_property(sprite, "modulate:a", 0.0, hide_tween_timer)
	hide_tween.tween_callback(do_hide)


func do_hide():
	collectable.can_be_picked = false


func reset_clown():
	hide_timer = hide_cooldown
	if hide_tween:
		hide_tween.kill()
	sprite.modulate.a = 1
	collectable.can_be_picked = true
	start_hiding = false
