extends Node2D
var color = Color(1, 0, 0)
var runs = 0
func _ready():
	var f = File.new()
	f.open("res://color.txt", File.READ); color = Color(f.get_as_text().strip_edges()); f.close()
	if f.file_exists("user://save.txt"):
		f.open("user://save.txt", File.READ); runs = int(f.get_as_text()); f.close()
	runs += 1
	f.open("user://save.txt", File.WRITE); f.store_string(str(runs)); f.close()
	OS.set_window_title("godot runs %d" % runs)
	update()
func _draw():
	draw_rect(Rect2(0, 0, 400, 600), color)
	draw_rect(Rect2(400, 0, 400, 600), Color(0, 1, 0) if runs > 1 else Color(1, 0, 0))
