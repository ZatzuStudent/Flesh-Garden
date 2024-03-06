extends Node2D

var in_pot = false

func _on_area_2d_area_entered(area):
	if area.is_in_group("pot_large"):
		in_pot = true

func _on_area_2d_area_exited(area):
	if area.is_in_group("pot_large"):
		in_pot = false
		
func _process(_delta):
	$"..".global_position = get_global_mouse_position()

func _input(event):
	if  event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if !event.pressed && in_pot == true:
				$"..".queue_free()
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed:
				$"..".queue_free()
