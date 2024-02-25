extends Node2D

func _process(_delta):
	
	rotation = -deg_to_rad((360/(GlobalScript.timePerday/(GlobalScript.ClockTimer+0.01)))+90)
