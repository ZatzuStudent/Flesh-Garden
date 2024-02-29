extends Node2D

var angel = preload("res://Scene/angels.tscn")
@onready var timer = $Timer

func _process(_delta):
	if GlobalScript.time_of_day == 1 && timer.time_left == 0:
		timer.start()
		timer.wait_time = 3
	elif GlobalScript.time_of_day != 1:
		timer.stop()
		timer.wait_time = 3

func _on_timer_timeout():
	var angels = angel.instantiate()
	angels.position = Vector2(randi_range(-706,880),randi_range(-470,470))
	add_child(angels)
	timer.wait_time = randi_range(1,3)
