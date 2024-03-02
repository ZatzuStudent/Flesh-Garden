extends Node2D

signal fruit_value(value)
signal growth_time(gtime)
signal harvest_time(htime)
signal plant_growth_sprite(sprite)
signal plant_type(type)

var palmfern_value = 2
var palmfern_growth_time = 7
var palmfern_harvest_time = 16
var palmfern_growth_sprite= {
	0 : preload("res://Art Assets/Growth/Plant Growth Spite_5.png"),
	1 : preload("res://Art Assets/Growth/Plant Growth Spite_6.png"),
	2 : preload("res://Art Assets/Growth/Plant Growth Spite_7.png"),
	3 : preload("res://Art Assets/Growth/Plant Growth Spite_8.png"),
	4 : preload("res://Art Assets/Growth/Plant Growth Spite_9.png")
}
var palmfern_type = 1

func _ready():
	emit_signal("fruit_value", palmfern_value)
	emit_signal("growth_time", palmfern_growth_time)
	emit_signal("harvest_time", palmfern_harvest_time)
	emit_signal("plant_growth_sprite", palmfern_growth_sprite)
	emit_signal("plant_type", palmfern_type)
	

