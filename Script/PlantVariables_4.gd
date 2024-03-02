extends Node2D

signal fruit_value(value)
signal growth_time(gtime)
signal harvest_time(htime)
signal plant_growth_sprite(sprite)
signal plant_type(type)

var pupmkinskull_value = 3
var pupmkinskull_growth_time = 25
var pupmkinskull_harvest_time = 25
var pupmkinskull_growth_sprite= {
	0 : preload("res://Art Assets/Growth/Plant Growth Spite_14.png"),
	1 : preload("res://Art Assets/Growth/Plant Growth Spite_15.png"),
	2 : preload("res://Art Assets/Growth/Plant Growth Spite_16.png"),
	3 : preload("res://Art Assets/Growth/Plant Growth Spite_17.png"),
	4 : preload("res://Art Assets/Growth/Plant Growth Spite_18.png"),
}
var pupmkinskull_type = 3

func _ready():
	emit_signal("fruit_value", pupmkinskull_value)
	emit_signal("growth_time", pupmkinskull_growth_time)
	emit_signal("harvest_time", pupmkinskull_harvest_time)
	emit_signal("plant_growth_sprite", pupmkinskull_growth_sprite)
	emit_signal("plant_type", pupmkinskull_type)
