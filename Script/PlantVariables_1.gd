extends Node2D

signal fruit_value(value)
signal growth_time(gtime)
signal harvest_time(htime)
signal plant_growth_sprite(sprite)
signal plant_type(type)

var eyeberry_value = 3
var eyeberry_growth_time = 5
var eyeberry_harvest_time = 6
var eyeberry_growth_sprite= {
	0 : preload("res://Art Assets/Growth/Plant Growth Spite_0.png"),
	1 : preload("res://Art Assets/Growth/Plant Growth Spite_1.png"),
	2 : preload("res://Art Assets/Growth/Plant Growth Spite_2.png"),
	3 : preload("res://Art Assets/Growth/Plant Growth Spite_3.png"),
	4 : preload("res://Art Assets/Growth/Plant Growth Spite_4.png")
}
var eyeberry_type = 0

func _ready():
	emit_signal("fruit_value", eyeberry_value)
	emit_signal("growth_time", eyeberry_growth_time)
	emit_signal("harvest_time", eyeberry_harvest_time)
	emit_signal("plant_growth_sprite", eyeberry_growth_sprite)
	emit_signal("plant_type", eyeberry_type)
	

