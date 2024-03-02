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
@onready var float_plus_crops = $"../Float Plus Crops"

var eye_wither_sprite = preload("res://Art Assets/Growth/Plant Growth Spite_4.5.png")
var hand_wither_sprite = preload("res://Art Assets/Growth/Plant Growth Spite_9.5.png")

var blood_can = 1

func _ready():
	isharvestTime = false
	need_blood.visible = false
	isblooding = false
	blood_water.visible = false
	float_plus_crops.visible = false
	
func _process(delta):
	if isharvestTime == false:
		blood_water.value -= blood_can * delta
	if isblooding == true:
		blood_water.value += 80 * delta
		blood_water.visible = true
	else:
		blood_water.visible = false
	if blood_water.value < blood_water.max_value/10:
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

@onready var plus_harvest = $"../Float Plus Crops/AnimationPlayer"
@onready var plus_label = $"../Float Plus Crops/Label"

var number_of_harvest = 0

func _on_harvest_area_2d_input_event(_viewport, event, _shape_idx):
	if  event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed && (plant_type == 0 || plant_type == 1):
			if plant_phase == 9:
				$"..".queue_free()
			elif isharvestTime == true:
				plant_phase = 5
				harvest_sfx.play()
				PlantBody.texture = plant_spritesheet[4]
				isharvestTime = false
				GlobalScript.storage[plant_type] += fruit_value
				number_of_harvest += 1
				harvest_timer.start()
				float_plus_crops.visible = true
				plus_label.text = str(fruit_value)
				plus_harvest.play("plus")
				if number_of_harvest >= 3:
					plant_phase = 9
					blood_can = 0
					harvest_timer.stop()
					if plant_type == 0:
						PlantBody.texture = eye_wither_sprite
					if plant_type == 1:
						PlantBody.texture = hand_wither_sprite
				
		
				
		if event.pressed && (plant_type == 2 || plant_type == 3):
			if isharvestTime == true:
				isharvestTime = false
				harvest_sfx.play()
				GlobalScript.storage[plant_type] += fruit_value
				$"../PlantBody".visible = false
				float_plus_crops.visible = true
				plus_label.text = str(fruit_value)
				plus_harvest.play("plus")
				await plus_harvest.animation_finished
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


