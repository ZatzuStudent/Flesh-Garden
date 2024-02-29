extends Node2D

func _process(_delta):
	global_position = get_global_mouse_position()

func _on_area_2d_area_exited(area):
	if area.is_in_group("pots") || area.is_in_group("seeds"):
		queue_free()