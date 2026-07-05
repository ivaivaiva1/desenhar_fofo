extends Node
class_name LineController

@onready var level_manager: LevelManager = get_parent() as LevelManager
@onready var line_rendering = get_parent().get_node("line_rendering")
@onready var line_collider = get_parent().get_node("line_collider")
@onready var draw_area: TextureRect = %draw_area

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


func _on_draw_area_gui_input(event: InputEvent) -> void:
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
	
	var result: Dictionary = get_last_valid_point(last_point, event.position)
	
	if result["blocked"]:
		add_point(result["point"])
		finish_line()
		return
	
	add_point(event.position)


func get_last_valid_point(from: Vector2, to: Vector2) -> Dictionary:
	var distance := from.distance_to(to)
	var steps := maxi(1, int(distance))
	
	var last_valid := from
	
	for i in range(steps + 1):
		var t := float(i) / float(steps)
		var p := from.lerp(to, t)
		
		if !can_draw_at(p):
			return {
				"blocked": true,
				"point": last_valid
			}
		
		last_valid = p
	
	return {
		"blocked": false,
		"point": to
	}


func can_draw_at(point: Vector2) -> bool:
	if !draw_area.get_global_rect().has_point(point):
		return false
	
	for control in get_tree().get_nodes_in_group("draw_blocker"):
		if control is Control and control.get_global_rect().has_point(point):
			return false
	
	return true


func start_line():
	var mouse_pos := get_viewport().get_mouse_position()
	
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
