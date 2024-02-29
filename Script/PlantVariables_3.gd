extends Node2D

signal fruit_value(value)
signal growth_time(gtime)
signal harvest_time(htime)
signal plant_growth_sprite(sprite)
signal plant_type(type)
var onionfoot_value = 2
var onionfoot_growth_time = 18
var onionfoot_harvest_time = 18

var onionfoot_growth_sprite= {
	0 : preload("res://Art Assets/Growth/Plant Growth Spite_10.png"),
	1 : preload("res://Art Assets/Growth/Plant Growth Spite_11.png"),
	2 : preload("res://Art Assets/Growth/Plant Growth Spite_12.png"),
	3 : preload("res://Art Assets/Growth/Plant Growth Spite_13.png")
}

var onionfoot_type = 2
func _ready():
	emit_signal("fruit_value", onionfoot_value)
	emit_signal("growth_time", onionfoot_growth_time)
	emit_signal("harvest_time", onionfoot_harvest_time)
	emit_signal("plant_growth_sprite", onionfoot_growth_sprite)
	emit_signal("plant_type", onionfoot_type)
	

