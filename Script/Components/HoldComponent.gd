extends Node2D

var isHolding
var oldPos
var movePos

func _ready():
	oldPos = global_position
	
func _process(_delta):
	if isHolding == true:
		$"..".global_position = get_global_mouse_position() - movePos

func _on_area_2d_input_event(_viewport, event, _shape_idx):
	if  event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			isHolding = true
			movePos = get_global_mouse_position() - global_position
			oldPos = global_position
		else:
			isHolding = false
			$"..".global_position = oldPos

