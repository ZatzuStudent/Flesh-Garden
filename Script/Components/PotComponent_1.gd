extends Node2D

signal pot_type(type)

var small_type = 1

func _ready():
	emit_signal("pot_type", small_type)
	

