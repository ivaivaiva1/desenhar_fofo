extends Node2D
class_name Bloon

var bloon_object: Collectable
var level_manager: LevelManager

@onready var sprite: Sprite2D = %Sprite
@onready var body: CollisionShape2D = %Body

var original_flash_color: Color
var original_flash_pct: float
var base_scale: Vector2
var sprite_base_scale: Vector2
@export var max_life: int = 3
@export var many_bobs: int =  6
@export var impulse_force: int = 400
var current_life: int
var is_dead: bool = false
var little_bob_scene: PackedScene = preload("uid://d0aen8rgrfni3")



func _ready() -> void:
	bloon_object = get_parent() as Collectable
	bloon_object.self_restore = true
	
	current_life = max_life
	
	base_scale = bloon_object.scale
	sprite_base_scale = sprite.scale
	sprite.material = sprite.material.duplicate()
	original_flash_color = sprite.material.get_shader_parameter("flash_color")
	original_flash_pct = sprite.material.get_shader_parameter("flash_pct")
	start_breathing()



func get_hited():
	if bloon_object.is_picked: return
	current_life -= 1
	if current_life <= 0:
		die()
		return
	SfxManager.play_sfx(SoundsList.BUBBLE_SOUND)
	do_flash()
	do_hited()


func spawn_little_bobs():
	var little_bob_instance = little_bob_scene.instantiate()
	get_tree().current_scene.add_child(little_bob_instance)
	little_bob_instance.global_position = self.global_position
	little_bob_instance.start(level_manager, many_bobs, impulse_force)



func die():
	bloon_object.is_picked = true
	body.set_deferred("disabled", true)
	sprite.visible = false
	HitFreeze.freeze(0.1, 0.3)
	ScreenShake.do_screen_shake(5, 0.3)
	SfxManager.play_sfx(SoundsList.BLOON_EXPLODE)
	spawn_little_bobs()


func reset():
	print("reset")
	bloon_object.is_picked = false
	body.set_deferred("disabled", false)
	sprite.visible = true
	current_life = max_life


var _breathing_tween: Tween = null
var _base_scale: Vector2
func start_breathing() -> void:
	return
	_base_scale = sprite.scale
	var breath_time := 2.5
	
	_breathing_tween = create_tween()
	_breathing_tween.set_loops()
	_breathing_tween.set_trans(Tween.TRANS_BOUNCE)
	_breathing_tween.set_ease(Tween.EASE_IN_OUT)
	
	_breathing_tween.tween_property(sprite, "scale", _base_scale * 1.05, breath_time)
	_breathing_tween.tween_property(sprite, "scale", _base_scale / 1.05, breath_time * 1.5)



var hited_tween: Tween
func do_hited():
	if hited_tween: hited_tween.kill()
	hited_tween = create_tween()
	
	var target_object := sprite
	var target_scale := sprite_base_scale
	var pump_sequence := [
		target_scale * 0.9,   
		target_scale * 1.2,  
		target_scale * 0.95,  
		target_scale * 1.1,   
		target_scale         
	]
	
	for i in pump_sequence.size() - 1:
		var duration := 0.08 + i * 0.04
		hited_tween.tween_property(target_object, "scale", pump_sequence[i], duration)
	
	hited_tween.tween_property(target_object, "scale", target_scale, 0.15)


var flash_tween: Tween
func do_flash():
	if flash_tween: flash_tween.kill()
	flash_tween = create_tween()
	var mat := sprite.material
	mat.set_shader_parameter("flash_color", Color.WHITE)
	mat.set_shader_parameter("flash_pct", 0.9)
	flash_tween.set_trans(Tween.TRANS_SINE)
	flash_tween.set_ease(Tween.EASE_OUT)
	
	#flash_tween.tween_method(func(v):
		#mat.set_shader_parameter("flash_color", original_flash_color.lerp(Color.WHITE, v))
		#mat.set_shader_parameter("flash_pct", lerp(original_flash_pct, 0.7, v))
	#, 0.0, 1.0, 0.08*1)
	
	flash_tween.tween_method(func(v):
		mat.set_shader_parameter("flash_color", Color.WHITE.lerp(original_flash_color, v))
		mat.set_shader_parameter("flash_pct", lerp(1.0, original_flash_pct, v)), 0.0, 1.0, 0.3)
