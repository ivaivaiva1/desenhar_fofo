extends RigidBody2D
class_name Player

var level_manager: LevelManager
@export var gravity_air: float = 100.0
@export var gravity_ground_down: float = 6000.0
@export var gravity_ground_up: float = 10


func _ready() -> void:
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
	
	apply_central_force(Vector2.DOWN * gravity * mass)


func auto_destroy():
	queue_free()
