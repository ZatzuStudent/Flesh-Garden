extends Node2D

var plant_type_1 = {
	0: {name = "seed_1", scene = preload("res://Scene/plant_1.tscn"), pos = Vector2(0, -57)},
	1: {name = "seed_2", scene = preload("res://Scene/plant_2.tscn"), pos = Vector2(16, -127)},
	2: {name = "seed_3", scene = preload("res://Scene/plant_3.tscn"), pos = Vector2(9, -135)},
	3: {name = "seed_4", scene = preload("res://Scene/plant_4.tscn"), pos = Vector2(-14, -111)}}

@onready var seed_collision = $"../SeedArea2D/CollisionShape2D2"
@onready var movepot_sfx = $"../AudioStreamPlayer2D"
@onready var placepot_sfx = $"../AudioStreamPlayer2D2"

var isHolding
var oldPotPos
var movePotPos
var isPlatform = false
var platform_pos
var pot_type
var hasPlant
var is_just_bought = true
var number_of_pots = 0

func _ready():
	seed_collision.disabled = false
	$"..".modulate = Color(1,1,1,.3)
	
func _process(_delta):
	if number_of_pots == 0 && onthePlatform == true:
		$"..".modulate = Color(1,1,1,1)
		isPlatform = true
	else:
		$"..".modulate = Color(1,1,1,.3)
		isPlatform = false

	if is_just_bought == true:
		$"..".global_position = get_global_mouse_position()
	if get_child_count() >  0:
		seed_collision.set_deferred("disabled", true)
	else:
		seed_collision.set_deferred("disabled", false)
	if isHolding == true:
		$"..".global_position = get_global_mouse_position() - movePotPos

var with_seed = null

func _on_seed_area_2d_area_entered(area):
	for i in plant_type_1:
		if area.is_in_group(plant_type_1[i].name):
			if i in [0,1] || (i in [2,3] && pot_type == 2):
				with_seed = i

func _on_seed_area_2d_area_exited(area):
	for i in plant_type_1:
		if area.is_in_group(plant_type_1[i].name):
			if i in [0,1] || (i in [2,3] && pot_type == 2):
				with_seed = null

func _input(event):
	if  event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT && !event.is_pressed():
			if with_seed != null:
				var instance = plant_type_1[with_seed].scene.instantiate()
				instance.position = Vector2(plant_type_1[with_seed].pos)
				call_deferred("add_child", instance)
				with_seed = null
			#to hold
			if isHolding == true:
				isHolding = false
				if isPlatform == false:
					$"..".global_position = oldPotPos
				if isPlatform == true:
					$"..".global_position.y = platform_pos
					is_just_bought = false
					placepot_sfx.play()
					if get_parent().has_node("SpawnArea2D"):
						$"../SpawnArea2D".queue_free()
				if !is_just_bought:
					number_of_pots = 0
		
		if event.button_index == MOUSE_BUTTON_RIGHT && event.is_pressed() && is_just_bought:
			$"..".queue_free()


func _on_area_2d_input_event(_viewport, event, _shape_idx):
	if  event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed && with_seed == null:
			isHolding = true
			movepot_sfx.play()
			movePotPos = get_global_mouse_position() - global_position
			oldPotPos = global_position

var platforms = {
	0 : {name= "platform_table", platform_pos_y = 178}, 
	1 : {name= "platform_wall_1", platform_pos_y = -199},
	2 : {name= "platform_wall_2", platform_pos_y = -87},
	3 : {name= "platform_stool", platform_pos_y = 143}}

var onthePlatform
func _on_platform_placer_area_2d_area_entered(area):
	if is_inside_tree():
		for i in platforms:
			if area in get_tree().get_nodes_in_group(platforms[i].name):
				onthePlatform = true
				platform_pos = platforms[i].platform_pos_y

func _on_platform_placer_area_2d_area_exited(area):
	if is_inside_tree():
		for i in platforms:
			if area in get_tree().get_nodes_in_group(platforms[i].name):
				onthePlatform = false

func _on_area_2d_area_entered(area):
	if area.is_in_group("pots") && isHolding == true:
		number_of_pots += 1
	if area.is_in_group("pots") && is_just_bought == true:
		number_of_pots += 1

func _on_area_2d_area_exited(area):
	if area.is_in_group("pots") && isHolding == true:
		number_of_pots -= 1
	if area.is_in_group("pots") && is_just_bought == true:
		number_of_pots -= 1

func _on_pot_component_pot_type(type):
	pot_type = type




