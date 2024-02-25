extends Node2D

@onready var hand = $HandSprite2D2

func _process(_delta):
	hand.rotation = -deg_to_rad((360/(GlobalScript.timePerday/(GlobalScript.ClockTimer+0.01)))+90)
