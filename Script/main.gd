extends Node

@onready var money = $Money
var customer_number
var customers = preload("res://Scene/customer_1.tscn")
var customer_last
var customer_now
@onready var MainTimer = $ClockTimer
@onready var day_colors = $Lights/DayColors

func _ready():
	var instance = customers.instantiate()
	instance.position = Vector2(-470,-216)
	call_deferred("add_child", instance)
	MainTimer.wait_time = GlobalScript.timePerday
	GlobalScript.time_of_day = 0

func _process(_delta):
	var sunrise = (MainTimer.wait_time-(MainTimer.wait_time-1))
	var sunset = (MainTimer.wait_time/2)
	var night = (MainTimer.wait_time/3)-5
	
	if MainTimer.time_left < sunrise && MainTimer.time_left > sunrise-.1 :
		day_colors.play("Sunrise")
		GlobalScript.time_of_day = 0
	elif MainTimer.time_left < night && MainTimer.time_left > night-.1:
		day_colors.play("night_time")
		GlobalScript.time_of_day = 1
	elif MainTimer.time_left < sunset && MainTimer.time_left > sunset-.1:
		day_colors.play("Sunset")
	await get_tree().create_timer(1).timeout
	
	if !has_node("Customer_1") && GlobalScript.time_of_day == 0:
		var instance = customers.instantiate()
		instance.position = Vector2(-470,-216)
		call_deferred("add_child", instance)
	$Day.text = str("Day: ", GlobalScript.day)
		
	money.text = str(GlobalScript.money)
	for i in range(4):
		get_node("Products/Label%d" % (i)).text = str(GlobalScript.storage[i])
		get_node("Products/Label4").text = str(GlobalScript.storage[9])
	GlobalScript.ClockTimer = MainTimer.time_left

func _on_get_area_2d_area_entered(area):
	if area in get_tree().get_nodes_in_group("seeds") || area in get_tree().get_nodes_in_group("pots"):
		GlobalScript.isEmpty = false

func _on_get_area_2d_area_exited(area):
	if area in get_tree().get_nodes_in_group("seeds") || area in get_tree().get_nodes_in_group("pots"):
		GlobalScript.isEmpty = true

func _on_clock_timer_timeout():
	GlobalScript.day += 1


