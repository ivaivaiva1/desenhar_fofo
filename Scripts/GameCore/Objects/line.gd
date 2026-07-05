class_name Line
extends RefCounted

var source_points := PackedVector2Array()
var render_points := PackedVector2Array()
var collision_points := PackedVector2Array()

var color := Color.DEEP_PINK
var width := 3.0
var collision := true
