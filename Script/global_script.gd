extends Node

var customer_love = {
	0 : 0,
	1 : 0,
	2 : 0,
	3 : 0,
	4 : 0,
}

var storage = {
	0: 20, #eye
	1: 20, #hand
	2: 20, #leg
	3: 20, #head
	4: 99999,
	5: 99999, 
	6: 99999, 
	7: 99999, 
	8: 99999,
	9: 20
}

var isEmpty = true
var money = 120
var customer_number
var cauldron = false
var ClockTimer = 180
var timePerday = 180
var day = 0
var daytime = 1
var frog_eaten = 0
var frog_size = 1
var watering = false
var is_cauldron_area = false

func _ready():
	customer_number = randi_range(0,4)
