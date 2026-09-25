extends Node2D
# Left half: colour read from a packaged file. Right half: red on the first run, green once a
# save from an earlier run was found. The run count is saved to user://save.txt and shown in the title.
var color := Color.RED
var runs := 0
func _ready():
	color = Color(FileAccess.get_file_as_string("res://color.txt").strip_edges())
	if FileAccess.file_exists("user://save.txt"):
		runs = int(FileAccess.get_file_as_string("user://save.txt"))
	runs += 1
	var f := FileAccess.open("user://save.txt", FileAccess.WRITE)
	f.store_string(str(runs))
	f.close()
	DisplayServer.window_set_title("godot runs %d" % runs)
	print("QVDBG godot runs ", runs, " persistent ", OS.is_userfs_persistent())
	queue_redraw()
func _draw():
	draw_rect(Rect2(0, 0, 400, 600), color)
	draw_rect(Rect2(400, 0, 400, 600), Color.GREEN if runs > 1 else Color.RED)
