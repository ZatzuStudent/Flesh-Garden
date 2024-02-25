extends Node2D

func _process(_delta):
	if GlobalScript.cauldron == true:
		$"..".queue_free()
