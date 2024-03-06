extends Node2D

func _ready():
	visible = false

func _input(_event):
	if Input.is_action_just_pressed("space"):
		if GlobalScript.paused == false:
			visible = true
			Engine.time_scale = 0
			GlobalScript.paused = true
			$Button.text = "Pause"
			GlobalScript.shop_open = 0
		else:
			visible = false
			Engine.time_scale = 1
			GlobalScript.paused = false
			$Button.text = "playing"
