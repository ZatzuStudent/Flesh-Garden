extends Node2D

@onready var growth_timer = $GrowthTimer

var fruit_value = 2

var heart_growth_sprite= {
	0 : preload("res://Art Assets/Growth/Plant Growth Spite_19.png"),
	1 : preload("res://Art Assets/Growth/Plant Growth Spite_20.png"),
	2 : preload("res://Art Assets/Growth/Plant Growth Spite_21.png"),
	3 : preload("res://Art Assets/Growth/Plant Growth Spite_22.png")
}
@onready var float_plus_crops = $"Float Plus Crops"

@onready var plus_harvest = $"Float Plus Crops/AnimationPlayer"
@onready var plus_label = $"Float Plus Crops/Label"

var plant_phase = 0

var isharvestTime
var plant_type = 9

func _ready():
	isharvestTime = false
	$PlantBody.texture = heart_growth_sprite[plant_phase]
	float_plus_crops.visible = false

func _on_growth_timer_timeout():
	plant_phase = plant_phase + 1
	$PlantBody.texture = heart_growth_sprite[plant_phase]
	if plant_phase == 3:
		growth_timer.stop()
		isharvestTime = true

func _on_harvest_area_2d_input_event(_viewport, event, _shape_idx):
	if  event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed && isharvestTime == true:
			GlobalScript.storage[plant_type] += fruit_value
			$PlantBody.visible = false
			float_plus_crops.visible = true
			plus_label.text = str(fruit_value)
			plus_harvest.play("plus")
			$".".queue_free()
		else:
			return
