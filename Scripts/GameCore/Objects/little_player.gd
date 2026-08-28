extends RigidBody2D
class_name LittlePlayer

@export var entity_type: SkinPicker.ENTITY_TYPE
@onready var sprite: Sprite2D = %Sprite
var controller: BobzinhoController

var gravity_air: float = 1100.0 
var gravity_ground_down: float = 9000.0 
var gravity_ground_up: float = 0
var max_speed: float = 2000


func _ready() -> void:
	SkinPicker.change_skin(entity_type, sprite)
	original_scale = sprite.scale
	
	contact_monitor = true
	max_contacts_reported = 4


func _process(_delta: float) -> void:
	if global_position.y > 1400:
		die()


func die():
	controller.kill(self)


func player_jump(force_x: float, force_y: float) -> void:
	linear_velocity = Vector2.ZERO
	angular_velocity = 0.0
	apply_impulse(Vector2(force_x, force_y))


func _integrate_forces(state: PhysicsDirectBodyState2D):
	var gravity: float = gravity_air
	if state.get_contact_count() > 0:
		if linear_velocity.y < 0:
			gravity = gravity_ground_up
		else:
			gravity = gravity_ground_down
			linear_velocity *= 1.02
			if abs(linear_velocity.x) < 70:
				linear_velocity.x += 1 * sign(linear_velocity.x)
	
	
	for i in state.get_contact_count():
		var collider := state.get_contact_collider_object(i)
		if !collider: return
		if collider.is_in_group("Pudim"):
			ScreenShake.do_screen_shake(1.5, 0.2)
			var normal := state.get_contact_local_normal(i)
			var pudim: Pudim = collider as Pudim
			
			linear_velocity += normal * pudim.pudim_force
			pudim.pump_pudim()
	apply_central_force(Vector2.DOWN * gravity * mass)
	linear_velocity.x = clamp(linear_velocity.x, -max_speed, max_speed)
	linear_velocity.y = clamp(linear_velocity.y, -max_speed, max_speed)


func make_yellow():
	sprite.modulate = Color.YELLOW


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


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Bloon"):
		var dir = (global_position - body.global_position).normalized()
		
		apply_central_impulse(dir * 10 * 1000000)
		pump_yuumy()
		
		var bloon: Bloon = body.get_parent() as Bloon
		if bloon: bloon.get_hited()
