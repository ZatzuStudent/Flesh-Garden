extends Node2D

var plant_type_1 = {
	0: {name = "seed_1", scene = preload("res://Scene/plant_1.tscn"), pos = Vector2(0,-58)},
	1: {name = "seed_2", scene = preload("res://Scene/plant_2.tscn"), pos = Vector2(15,-129)}}

@onready var seed_collision = $SeedArea2D/CollisionShape2D2

var isHolding
var oldPotPos
var movePotPos
var isPlatform
var isfrog
var number_of_pots = 0
var is_just_bought = true
var can_putdown = false
var on_platform = false

func _ready():
	z_index = -11
	seed_collision.disabled = false
	isHolding = false
	isPlatform = false
	oldPotPos = $".".global_position
	modulate = Color(1,1,1,.3)
	isfrog = false
var with_seed = null
func _on_seed_area_2d_area_entered(area):
	for i in plant_type_1:
		if area.is_in_group(plant_type_1[i].name):
			if i in [0,1]:
				with_seed = i

func _on_seed_area_2d_area_exited(area):
	for i in plant_type_1:
		if area.is_in_group(plant_type_1[i].name):
			if i in [0,1]:
				with_seed = null

func _process(_delta):
	if number_of_pots == 0 && on_platform == true:
		modulate = Color(1,1,1,1)
		can_putdown = true
	else:
		modulate = Color(1,1,1,.3)
		can_putdown = false

	if is_just_bought == true:
		global_position = get_global_mouse_position()
	if isHolding == true:
		global_position = get_global_mouse_position() - movePotPos
		
	if get_child_count() >  5:
		seed_collision.set_deferred("disabled", true)
	else:
		seed_collision.set_deferred("disabled", false)
	
func _on_area_2d_input_event(_viewport, event, _shape_idx):
	if  event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			isHolding = true
			movePotPos = get_global_mouse_position() - global_position
			oldPotPos = global_position
			if with_seed != null:
				var instance = plant_type_1[with_seed].scene.instantiate()
				instance.position = Vector2(plant_type_1[with_seed].pos)
				call_deferred("add_child", instance)
				with_seed = null

func _input(event):
	if  event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT && !event.pressed:
			if isfrog == true:
				queue_free()
				GlobalScript.frog_eaten += 1
			if isHolding == true:
				isHolding = false
				if can_putdown == true:
					is_just_bought = false
					if has_node("SpawnArea2D"):
						$SpawnArea2D.queue_free()
				else:
					global_position = oldPotPos
				if is_just_bought == false:
					number_of_pots = 0
		if event.button_index == MOUSE_BUTTON_RIGHT && event.is_pressed() && is_just_bought:
			queue_free()

func _on_area_2d_2_area_entered(area):
	if area.is_in_group("platform_hanging"):
		on_platform = true
func _on_area_2d_2_area_exited(area):
	if area.is_in_group("platform_hanging"):
		on_platform = false

func _on_area_2d_area_entered(area):
	if area.is_in_group("frogs"):
		isfrog = true
	if area.is_in_group("pots") && isHolding == true:
		number_of_pots += 1
	if area.is_in_group("pots") && is_just_bought == true:
		number_of_pots += 1

func _on_area_2d_area_exited(area):
	if area.is_in_group("frogs"):
		isfrog = false
	if area.is_in_group("pots") && isHolding == true:
		number_of_pots -= 1
	if area.is_in_group("pots") && is_just_bought == true:
		number_of_pots -= 1



