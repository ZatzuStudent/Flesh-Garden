extends RigidBody2D

var isHolding

func _process(_delta):
	if isHolding == true:
		position = get_global_mouse_position()
		rotation = 0
		if GlobalScript.cauldron == false:
			global_position.x = clamp(get_global_mouse_position().x, -546, -402)
			global_position.y = clamp(get_global_mouse_position().y, 0, 239)
		elif GlobalScript.cauldron == true:
			global_position.x = clamp(get_global_mouse_position().x, -601, -343)
			global_position.y = clamp(get_global_mouse_position().y, -80, 129) 

func _on_area_2d_input_event(_viewport, event, _shape_idx):
	if  event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			isHolding = true
		else:
			isHolding = false
func _input(event):
	if  event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
		if !event.pressed:
			isHolding = false

func _on_area_2d_area_entered(area):
	if area.is_in_group("down_boarder"):
		$".".global_position = Vector2(-487,-778)
