extends Node2D

func _process(_delta):
	if GlobalScript.cauldron == true:
		$".".visible = true
	

func _on_area_2d_2_input_event(_viewport, event, _shape_idx):
	if  event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			queue_free()
