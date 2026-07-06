extends Node2D
class_name LineController

@onready var level_manager: LevelManager = get_parent() as LevelManager
@onready var line_rendering = get_parent().get_node("line_rendering")
@onready var line_collider = get_parent().get_node("line_collider")
@onready var draw_area: Area2D = %draw_area

var current_line: Line
var is_drawing: bool = false

signal line_started(line: Line)
signal point_added(line: Line, point: Vector2)
signal line_finished(line: Line)


func _ready():
	update_line_color()
	WorldIsChangingEmmiter.world_is_changing.connect(update_line_color)
	line_started.connect(line_rendering._on_line_started)
	point_added.connect(line_rendering._on_point_added)
	line_finished.connect(line_rendering._on_line_finished)
	line_finished.connect(line_collider.add_line)


func _on_draw_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if level_manager.current_state == level_manager.GAME_STATE.ROLLING:
		return
	
	if event is InputEventMouseButton:
		handle_mouse_button(event)
	elif event is InputEventMouseMotion:
		handle_mouse_motion(event)



func handle_mouse_button(event: InputEventMouseButton):
	if event.button_index != MOUSE_BUTTON_LEFT:
		return
	
	if event.pressed:
		start_line()
	else:
		finish_line()


func handle_mouse_motion(event: InputEventMouseMotion):
	if !is_drawing:
		return
	
	var last_point: Vector2 = current_line.source_points[-1]
	var result: Dictionary = get_last_valid_point(last_point, get_global_mouse_position())
	
	if result["blocked"]:
		var last_valid_point = result["point"]
		add_point(last_valid_point)
		finish_line() 
		return
	
	add_point(get_global_mouse_position())


func get_last_valid_point(from: Vector2, to: Vector2) -> Dictionary:
	var distance := from.distance_to(to)
	var steps := maxi(1, int(distance))
	var last_valid := from
	
	for i in range(steps + 1):
		var t := float(i) / float(steps)
		var p := from.lerp(to, t)
		
		if !can_draw_at(p):
			return { "blocked": true, "point": last_valid }
		
		last_valid = p
	
	return { "blocked": false, "point": to }


func can_draw_at(point: Vector2) -> bool:
	var query := PhysicsPointQueryParameters2D.new()
	query.position = point
	query.collide_with_areas = true
	query.collide_with_bodies = false
	query.collision_mask = 1
	
	var space_state := get_viewport().world_2d.direct_space_state
	var hits := space_state.intersect_point(query)
	if hits.is_empty():
		return false
	
	var inside_draw_area := false
	
	for hit in hits:
		var collider = hit.collider
		
		if collider.is_in_group("DrawBlocker"):
			return false
		
		if collider.is_in_group("DrawArea"):
			inside_draw_area = true
	
	return inside_draw_area


func start_line():
	var mouse_pos := get_global_mouse_position()
	
	if !can_draw_at(mouse_pos):
		return
	
	is_drawing = true
	current_line = Line.new()
	
	add_point(mouse_pos)
	line_started.emit(current_line)


func finish_line():
	if !is_drawing:
		return
	
	is_drawing = false
	
	if current_line.source_points.size() >= 2:
		line_finished.emit(current_line)
	
	current_line = null


func add_point(point: Vector2):
	current_line.source_points.append(point)
	point_added.emit(current_line, point)


@onready var WorldIsChangingEmmiter: LoadLevel = get_tree().get_first_node_in_group("WorldIsChangingEmmiter") as LoadLevel
func update_line_color():
	line_rendering.line_color = SkinPicker.line_color()
