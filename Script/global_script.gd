extends Node

var customer_love = {
	0 : 0,
	1 : 0,
	2 : 0,
	3 : 0,
	4 : 0,
}

var storage = {
	0: 0, #eye
	1: 0, #hand
	2: 0, #leg
	3: 0, #head
	4: 99999,
	5: 99999, 
	6: 99999, 
	7: 99999, 
	8: 99999,
	9: 0
}

var crop_numbers = [0, 1, 8]

var timePerday = 180 #constant
var ClockTimer = 180 #chages
var money = 120
var customer_number
var cauldron = false
var day = 1
var time_of_day = 0
var watering = false
var is_cauldron_area = false
var paused = false
var shop_open = 1

func _ready():
	customer_number = randi_range(0,4)
