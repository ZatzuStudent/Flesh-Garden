extends Node2D

var isfrog

func _ready():
	isfrog = false

func _on_area_2d_area_entered(area):
	if area.is_in_group("frogs"):
		isfrog = true
		modulate = Color(1,1,1,1)

func _on_area_2d_area_exited(area):
	if area.is_in_group("frogs"):
		isfrog = false
		modulate = Color(1,1,1,.3)

func _on_area_2d_input_event(_viewport, event, _shape_idx):
	if  event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
		if !event.pressed && isfrog == true:
			queue_free()
			GlobalScript.frog_eaten += 1
