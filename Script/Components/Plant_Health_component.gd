extends Node2D

var angels_in_plant = 0

@onready var health_bar = $ProgressBar

func _process(_delta):
	if angels_in_plant == 0:
		health_bar.value += 1
		health_bar.visible = false
	else:
		health_bar.value -= .1*angels_in_plant
		health_bar.visible = true
		
	if health_bar.value <= 0:
		$"..".queue_free()

func _on_harvest_area_2d_area_entered(area):
	if area.is_in_group("angel"):
		angels_in_plant += 1

func _on_harvest_area_2d_area_exited(area):
	if area.is_in_group("angel"):
		angels_in_plant -= 1
