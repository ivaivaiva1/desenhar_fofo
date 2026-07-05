extends RigidBody2D
class_name Player

var level_manager: LevelManager

@export var entity_type: SkinPicker.ENTITY_TYPE
@onready var sprite: Sprite2D = %Sprite

@export var gravity_air: float = 100.0
@export var gravity_ground_down: float = 6000.0
@export var gravity_ground_up: float = 10


func _ready() -> void:
	SkinPicker.change_skin(entity_type, sprite)
	original_scale = sprite.scale
	
	contact_monitor = true
	max_contacts_reported = 4


func _process(_delta: float) -> void:
	if level_manager == null: return
	if global_position.y > 750:
		level_manager.start_drawning()


func _integrate_forces(state: PhysicsDirectBodyState2D):
	var gravity: float = gravity_air
	if state.get_contact_count() > 0:
		if linear_velocity.y < 0:
			gravity = gravity_ground_up
		else:
			gravity = gravity_ground_down
		
	for i in state.get_contact_count():
		var collider := state.get_contact_collider_object(i)
		
		if collider.is_in_group("Pudim"):
			var normal := state.get_contact_local_normal(i)
			var pudim: Pudim = collider as Pudim
			
			linear_velocity += normal * pudim.pudim_force
			pudim.pump_pudim()
	apply_central_force(Vector2.DOWN * gravity * mass)



var original_scale: Vector2
var pump_tween: Tween
func pump_yuumy():
	if pump_tween: pump_tween.kill()
	sprite.scale = original_scale
	
	pump_tween = create_tween()
	
	pump_tween.tween_property(
		sprite,
		"scale",
		original_scale * randf_range(1.25, 1.35),
		0.1
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	pump_tween.tween_property(
		sprite,
		"scale",
		original_scale * randf_range(0.75, 0.85),
		0.095
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	pump_tween.tween_property(
		sprite,
		"scale",
		original_scale * randf_range(1.10, 1.20),
		0.088
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	pump_tween.tween_property(
		sprite,
		"scale",
		original_scale * randf_range(0.85, 0.95),
		0.077
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	pump_tween.tween_property(
		sprite,
		"scale",
		original_scale,
		0.064
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)



func auto_destroy():
	queue_free()
