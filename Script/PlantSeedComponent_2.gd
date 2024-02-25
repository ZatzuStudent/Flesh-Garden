extends Node2D

func _process(_delta):
	$"..".global_position = get_global_mouse_position()

func _input(event):
	if event is InputEventMouseButton && event.button_index == 1:
		if event.is_pressed() && inPot == true:
			$"..".queue_free()

var inPot = false

func _on_area_2d_area_entered(area):
	
	if area.is_in_group("pot_large"):
		inPot = true
		$"..".queue_free()
func _on_area_2d_area_exited(area):
	if area.is_in_group("pot_large"):
		inPot = false
