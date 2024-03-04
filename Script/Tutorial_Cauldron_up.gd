extends Node2D

@onready var animation_player = $AnimationPlayer


func _process(_delta):
	if GlobalScript.cauldron == true:
		$".".visible = true
	

func _on_area_2d_2_input_event(_viewport, event, _shape_idx):
	if  event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			animation_player.play("new_animation")
			await animation_player.animation_finished
			queue_free()
