extends Node2D

var heart_fruit = preload("res://Scene/plant_5.tscn")
@onready var new_fruit_timer = $NewFruitTimer
var intimer

func _ready():
	intimer = false
	randi()
	new_fruit_timer.wait_time = randi_range(25,65)
	new_fruit_timer.one_shot = false

func _process(_delta):
	if GlobalScript.day >= 6:
		if get_child_count() == 1:
			if intimer == false:
				intimer = true
				new_fruit_timer.start()

func _on_new_fruit_timer_timeout():
	var instance = heart_fruit.instantiate()
	instance.position = Vector2(0,0)
	call_deferred("add_child", instance)
	new_fruit_timer.stop()
	await get_tree().create_timer(5).timeout
	intimer = false
	
