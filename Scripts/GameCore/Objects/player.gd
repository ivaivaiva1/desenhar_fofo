extends RigidBody2D
class_name Player

var level_manager: LevelManager
var current_level: Level

@export var entity_type: SkinPicker.ENTITY_TYPE
@onready var sprite: Sprite2D = %Sprite

var gravity_air: float = 2000.0
var gravity_ground_down: float = 7000.0
var gravity_ground_up: float = 700
var grounded_time: float = 0.4
@onready var label: Label = %Label

var max_speed: float = 2000.0
var grounded := false
var grounded_timer := 0.0


func _ready() -> void:
	SkinPicker.change_skin(entity_type, sprite)
	original_scale = sprite.scale
	
	contact_monitor = true
	max_contacts_reported = 4


func _process(_delta: float) -> void:
	if grounded:
		label.text = str(freeze)
	else:
		label.text = str(freeze)
	if level_manager == null:
		return
	if global_position.y > 1400:
		die()



func die():
	SfxManager.play_sfx(SoundsList.DEATH_SFX)
	level_manager.start_drawning()


func player_jump(force_x: float, force_y: float) -> void:
	if freeze: return
	linear_velocity = Vector2.ZERO
	angular_velocity = 0.0
	apply_impulse(Vector2(force_x, force_y))
	print(angular_velocity)


func _integrate_forces(state: PhysicsDirectBodyState2D):
	if freeze: return
	var has_ground_contact := false
	
	for i in state.get_contact_count():
		var collider := state.get_contact_collider_object(i)
		
		
		if collider.is_in_group("Line"):
			print("ta na linha")
			var normal := state.get_contact_local_normal(i)
			var tangent := Vector2(-normal.y, normal.x)
			if tangent.dot(linear_velocity) < 0.0:
				tangent = -tangent
			var speed := linear_velocity.length()
			linear_velocity = tangent * speed
		
		if collider.is_in_group("Pudim"):
			ScreenShake.do_screen_shake(1.5, 0.2)
			
			var normal := state.get_contact_local_normal(i)
			var pudim: Pudim = collider as Pudim
			
			linear_velocity += normal * pudim.pudim_force
			pudim.pump_pudim()
		
		if state.get_contact_local_normal(i).y < -0.26:
			has_ground_contact = true
	
	if has_ground_contact:
		grounded = true
		grounded_timer = grounded_time
	elif grounded:
		grounded_timer -= state.step
		if grounded_timer <= 0.0:
			grounded = false
	
	
	var target_gravity: float = gravity_air
	if grounded:
		if has_ground_contact:
			if linear_velocity.y < 0.0:
				target_gravity = gravity_ground_up
			else:
				target_gravity = gravity_ground_down
		else:
			target_gravity = gravity_ground_up
	
	gravity_scale = target_gravity / 980.0



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
