extends Node2D

signal pot_type(type)

var big_type = 2

func _ready():
	emit_signal("pot_type", big_type)
	

