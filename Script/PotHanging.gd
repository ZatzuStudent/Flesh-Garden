extends Node2D

var plant_type_1 = {
	"seed_1": {"scene": preload("res://Scene/plant_1.tscn"), "pos": Vector2(0,-58)},
	"seed_2": {"scene": preload("res://Scene/plant_2.tscn"), "pos": Vector2(15,-129)},}

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

func _on_seed_area_2d_area_entered(area):
	for group1 in plant_type_1.keys():
		if area in get_tree().get_nodes_in_group(group1):
			var instance = plant_type_1[group1]["scene"].instantiate()
			instance.global_position = plant_type_1[group1]["pos"]
			call_deferred("add_child", instance)
			seed_collision.set_deferred("disabled", true)

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
	
func _on_area_2d_input_event(_viewport, event, _shape_idx):
	if  event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			isHolding = true
			movePotPos = get_global_mouse_position() - global_position
			oldPotPos = global_position

func _input(event):
	if  event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
		if !event.pressed:
			if isfrog == true:
				queue_free()
				GlobalScript.frog_eaten += 1
			if isHolding == true:
				isHolding = false
				if can_putdown == true:
					is_just_bought = false
				else:
					global_position = oldPotPos
				if !is_just_bought:
					number_of_pots = 0

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
