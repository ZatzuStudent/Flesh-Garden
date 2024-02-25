extends Node2D

var toEat = false
	
func _input(event):
	if  event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
		if !event.pressed:
			if toEat == true:
				$Label.queue_free()
var frog_areas = ["pot", "seeds", "potions"]

func _on_area_2d_area_entered(area):
	if is_inside_tree():
		for i in frog_areas:
			if area.is_in_group(i):
				toEat = true

func _on_area_2d_area_exited(area):
	if is_inside_tree():
		for i in frog_areas:
			if area.is_in_group(i):
				toEat = false

func _on_area_2d_2_input_event(_viewport, event, _shape_idx):
	if  event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			$Label2.queue_free()
			$Label3.visible = true
			$Label4.visible = true

func _on_area_2d_2_input_event2(_viewport, event, _shape_idx):
	if  event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			$Label3.queue_free()

func _on_area_2d_2_input_event3(_viewport, event, _shape_idx):
	if  event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			$Label4.queue_free()
