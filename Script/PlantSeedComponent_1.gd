extends Node2D

func _on_area_2d_area_entered(area):
	if area.is_in_group("pot"):
		$"..".queue_free()

func _process(_delta):
	$"..".global_position = get_global_mouse_position()


