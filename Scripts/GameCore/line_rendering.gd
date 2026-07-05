extends Node2D
class_name LineRendering

var lines: Array[Line] = []
var line_color: Color


func add_line(line: Line):
	lines.append(line)
	queue_redraw()


func remove_line(line: Line):
	lines.erase(line)
	queue_redraw()


func clear():
	lines.clear()
	queue_redraw()


func refresh():
	queue_redraw()


func _draw():
	for line in lines:
		if line.source_points.size() < 2: continue
		draw_polyline(
			line.source_points,
			line_color,
			line.width
		)


func _on_line_started(line: Line):
	lines.append(line)
	queue_redraw()


func _on_point_added(_line: Line, _point: Vector2):
	queue_redraw()


func _on_line_finished(_line: Line):
	queue_redraw()
