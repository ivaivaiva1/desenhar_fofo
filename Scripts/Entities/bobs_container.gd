extends Node2D
class_name BobContainer

var level_manager: LevelManager

var force_strength: float = 500
var torque_multiplier: float = 30.0
var torque_limit: float = 20000.0

var little_bob_scene: PackedScene = preload("uid://djfkfgkv6w1hy")
@onready var spawn_area: CollisionShape2D = %spawn_area


func start(bob_count: int, explosion_force: float) -> void:
	randomize()
	force_strength = explosion_force
	for i in bob_count:
		if level_manager.current_state != level_manager.GAME_STATE.ROLLING: 
			queue_free()
			return
		var bobzinho_instance := spawn_bob(get_spawn_point())
		apply_impulse(bobzinho_instance)
		if i == bob_count - 1:
			auto_destroy()
		await get_tree().create_timer(0.05).timeout


func apply_impulse(little_bob: LittlePlayer):
	var dir = (little_bob.global_position - global_position).normalized()
	little_bob.linear_velocity = dir * force_strength
	
	var torque_from_push = clamp(dir.x * torque_multiplier * force_strength, -torque_limit, torque_limit)
	little_bob.apply_torque_impulse(torque_from_push)


func spawn_bob(spawn_pos: Vector2) -> LittlePlayer:
	var little_bob_instance = little_bob_scene.instantiate()
	var bobzinho_controller: BobzinhoController = level_manager.load_level.level_instance.bobzinho_controller
	bobzinho_controller.add_child(little_bob_instance)
	bobzinho_controller.append_bobzinho(little_bob_instance)
	little_bob_instance.global_position = spawn_pos
	return little_bob_instance


func get_spawn_point() -> Vector2:
	var shape := spawn_area.shape as CircleShape2D
	var radius := shape.radius
	
	var angle := randf() * TAU
	var distance := sqrt(randf()) * radius
	
	var random_point := Vector2.from_angle(angle) * distance
	
	return spawn_area.to_global(random_point)



func auto_destroy():
	queue_free()
