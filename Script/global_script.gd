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
	2: 20, #leg
	3: 20, #head
	4: 99999,
	5: 99999, 
	6: 99999, 
	7: 99999, 
	8: 99999,
	9: 20
}

var crop_numbers = [0, 1, 8] 

var money = 10000
var timePerday = 180 #constant
var ClockTimer = 180 #chages
var holding_potion = false
var customer_number
var cauldron = false
var day = 1
var time_of_day = 0
var paused = false
var shop_open = 1
var is_cauldron_area = false

var isEmpty = true

var frog_eaten = 0
var frog_size = 1
var watering = false
var all_bought = false

func _ready():
	customer_number = randi_range(0,4)
