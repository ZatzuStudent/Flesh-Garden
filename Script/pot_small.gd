extends Node2D

var plant_type_1 = {
	"seed_1": {"scene": preload("res://Scene/plant_1.tscn"), "pos": Vector2(0, -57)},
	"seed_2": {"scene": preload("res://Scene/plant_2.tscn"), "pos": Vector2(16, -127)},}
var plant_type_2 = {
	"seed_3": {"scene2": preload("res://Scene/plant_3.tscn"), "pos": Vector2(9, -135)},
	"seed_4": {"scene2": preload("res://Scene/plant_4.tscn"), "pos": Vector2(-14, -111)}}

@onready var seed_collision = $"../SeedArea2D/CollisionShape2D2"
@onready var movepot_sfx = $"../AudioStreamPlayer2D"
@onready var placepot_sfx = $"../AudioStreamPlayer2D2"

var isHolding
var oldPotPos
var movePotPos
var isPlatform
var platform_pos
var pot_type
var hasPlant
var is_just_bought = true

func _ready():
	seed_collision.disabled = false
	isPlatform = false
	$"..".modulate = Color(1,1,1,1)
	
func _process(_delta):
	if is_just_bought == true:
		$"..".global_position = get_global_mouse_position()
	if get_child_count() >  0:
		seed_collision.set_deferred("disabled", true)
	else:
		seed_collision.set_deferred("disabled", false)
	if isHolding == true:
		$"..".global_position = get_global_mouse_position() - movePotPos

func _on_seed_area_2d_area_entered(area):
	for group1 in plant_type_1.keys():
		if area in get_tree().get_nodes_in_group(group1) and pot_type in [1,  2]:
			var instance = plant_type_1[group1]["scene"].instantiate()
			instance.global_position = plant_type_1[group1]["pos"]
			call_deferred("add_child", instance)
	for group2 in plant_type_2.keys():
		if area in get_tree().get_nodes_in_group(group2) and pot_type in [2]:
			var instance = plant_type_2[group2]["scene2"].instantiate()
			instance.position = plant_type_2[group2]["pos"]
			call_deferred("add_child", instance)

var is_seed_pressed = false

func _input(event):
	if event is InputEventMouseButton && event.button_index == 1:
		if event.is_pressed():
			print('pressed')
			is_seed_pressed = true
		else:
			print('notpressed')
			is_seed_pressed = false

func _on_area_2d_input_event(_viewport, event, _shape_idx):
	if  event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			isHolding = true
			movepot_sfx.play()
			movePotPos = get_global_mouse_position() - global_position
			oldPotPos = global_position
		elif isHolding == true:
			isHolding = false
			if isPlatform == false:
				$"..".global_position = oldPotPos
			if isPlatform == true:
				$"..".global_position.y = platform_pos
				is_just_bought = false
				placepot_sfx.play()

var platforms = {
	0 : {name= "platform_table", platform_pos_y = 178}, 
	1 : {name= "platform_wall_1", platform_pos_y = -199},
	2 : {name= "platform_wall_2", platform_pos_y = -87},
	3 : {name= "platform_stool", platform_pos_y = 143}}

var onthePlatform
func _on_platform_placer_area_2d_area_entered(area):
	if is_inside_tree() && inPot == false:
		for i in platforms:
			if area in get_tree().get_nodes_in_group(platforms[i].name):
				isPlatform = true
				onthePlatform = true
				platform_pos = platforms[i].platform_pos_y
				$"..".modulate = Color(1,1,1,1)

func _on_platform_placer_area_2d_area_exited(area):
	if is_inside_tree() || inPot == true:
		for i in platforms:
			if area in get_tree().get_nodes_in_group(platforms[i].name):
				isPlatform = false
				onthePlatform = false
				platform_pos = platforms[i].platform_pos_y
				$"..".modulate = Color(1,1,1,.3)

func _on_pot_component_pot_type(type):
	pot_type = type

var inPot = false

func _on_area_2d_area_entered(area):
	if area.is_in_group("pot") && isHolding == true:
		inPot = true
		$"..".modulate = Color(1,1,1,.3)
		isPlatform = false
func _on_area_2d_area_exited(area):
	if area.is_in_group("pot") && isHolding == true:
		inPot = false
		if onthePlatform == true:
			isPlatform = true
			$"..".modulate = Color(1,1,1,1)






