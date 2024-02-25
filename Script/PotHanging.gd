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

func _ready():
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

var is_just_bought = true

func _process(_delta):
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
		else:
			isHolding = false
			if isPlatform == true:
				is_just_bought = false
			elif isPlatform == false:
				global_position = oldPotPos

func _on_area_2d_2_area_entered(area):
	if area in get_tree().get_nodes_in_group("platform_hanging"):
		isPlatform = true
		modulate = Color(1,1,1,1)

func _on_area_2d_2_area_exited(area):
	if area in get_tree().get_nodes_in_group("platform_hanging"):
		isPlatform = false
		modulate = Color(1,1,1,.5)

func _input(event):
	if  event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
		if !event.pressed && isfrog == true:
			queue_free()
			GlobalScript.frog_eaten += 1

func _on_area_2d_area_entered(area):
	if area.is_in_group("frogs"):
		isfrog = true

func _on_area_2d_area_exited(area):
	if area.is_in_group("frogs"):
		isfrog = false
