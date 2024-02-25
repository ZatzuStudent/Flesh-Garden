extends Node2D

var crop_type= {
	0 : preload("res://Scene/crop_eyeball.tscn"),
	1 : preload("res://Scene/crop_hands.tscn"),
	2 : preload("res://Scene/crop_leg.tscn"),
	3 : preload("res://Scene/crop_head.tscn"),
	9 : preload("res://Scene/crop_heart.tscn")
}

func _on_parts_area_2d_input_event(_viewport, event, _shape_idx, i):
	if  event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
		if GlobalScript.storage[i] > 0:
			var instance = crop_type[i].instantiate()
			instance.position = get_global_mouse_position()
			call_deferred("add_sibling", instance)
		
