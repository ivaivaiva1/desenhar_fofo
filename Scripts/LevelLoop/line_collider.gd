extends Node

class_name LineCollider

var bodies: Array[StaticBody2D] = []
var lines: Array[Line] = []


func add_line(line: Line):
	lines.append(line)
	_build_collision(line)


func remove_line(line: Line):
	var index = lines.find(line)
	if index == -1: return
	
	lines.remove_at(index)
	
	var body = bodies[index]
	body.queue_free()
	bodies.remove_at(index)


func clear():
	for body in bodies:
		body.queue_free()
	
	bodies.clear()
	lines.clear()


func _build_collision(line: Line):
	if line.source_points.size() < 2: return
	var body = StaticBody2D.new()
	get_tree().current_scene.add_child(body)
	
	var points = line.source_points
	for i in range(points.size() - 1):
		
		var a = points[i]
		var b = points[i + 1]
		
		var segment = CollisionShape2D.new()
		var shape = SegmentShape2D.new()
		
		shape.a = a
		shape.b = b
		
		segment.shape = shape
		body.add_child(segment)
	
	bodies.append(body)
