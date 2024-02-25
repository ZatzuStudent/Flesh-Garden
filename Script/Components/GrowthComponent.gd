extends Node2D

@onready var PlantBody = $"../PlantBody"
@onready var GrowthTimer = $"../GrowthTimer"
@onready var blood_water = $"../BloodWater"
@onready var need_blood = $"../NeedBlood"
@onready var harvest_timer = $"../harvest_timer"
@onready var harvest_sfx = $"../AudioStreamPlayer2D"

var plant_phase = 0

var isharvestTime
var isblooding
var harvest_time
var plant_type
var fruit_value
var plant_spritesheet


func _ready():
	isharvestTime = false
	need_blood.visible = false
	isblooding = false
	blood_water.visible = false
	
func _process(delta):
	if isharvestTime == false:
		blood_water.value -= 1 * delta
	if isblooding == true:
		blood_water.value += 80 * delta
		blood_water.visible = true
	else:
		blood_water.visible = false
	if blood_water.value < 30:
		blood_water.visible = true
		need_blood.visible = true
		GrowthTimer.paused = true
	else:
		need_blood.visible = false
		GrowthTimer.paused = false


func _on_growth_timer_timeout():
	plant_phase = plant_phase + 1
	PlantBody.texture = plant_spritesheet[plant_phase]
	if (plant_type == 0 || plant_type == 1) && plant_phase == 3:
		GrowthTimer.stop()
		isharvestTime = true
		print('harvest')
		
	if (plant_type == 2 || plant_type == 3) && plant_phase == (plant_spritesheet.size()-1):
		GrowthTimer.stop()
		isharvestTime = true


func _on_harvest_area_2d_input_event(_viewport, event, _shape_idx):
	if  event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed && (plant_type == 0 || plant_type == 1):
			if isharvestTime == true:
				plant_phase = 5
				harvest_sfx.play()
				PlantBody.texture = plant_spritesheet[4]
				isharvestTime = false
				GlobalScript.storage[plant_type] += fruit_value
				harvest_timer.start()
				
		if event.pressed && (plant_type == 2 || plant_type == 3):
			if plant_phase == plant_spritesheet.size()-1:
				harvest_sfx.play()
				GlobalScript.storage[plant_type] += fruit_value
				$"..".queue_free()

func _on_harvest_timer_timeout():
	PlantBody.texture = plant_spritesheet[3]
	isharvestTime = true


func _on_blooding_area_2d_area_entered(area):
	if area in get_tree().get_nodes_in_group("bloodCan"):
		isblooding = true

func _on_blooding_area_2d_area_exited(area):
	if is_inside_tree() and area in get_tree().get_nodes_in_group("bloodCan"):
		isblooding = false
	else:
		return

func _on_blood_water_value_changed(value):
	if value == 0:
		GrowthTimer.set_paused(true)
	else:
		GrowthTimer.set_paused(false)


func _on_plant_variables_fruit_value(value):
	fruit_value = value
func _on_plant_variables_growth_time(gtime):
	GrowthTimer.wait_time = gtime
func _on_plant_variables_plant_growth_sprite(sprite):
	plant_spritesheet = sprite
	PlantBody.texture = plant_spritesheet[plant_phase]
func _on_plant_variables_plant_type(type):
	plant_type = type
func _on_plant_variables_harvest_time(htime):
	harvest_timer.wait_time = htime

