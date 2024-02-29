extends Node2D

var isHolding
var oldPotPos
var movePotPos

var upgrade_types = {
	0 : {scene = preload("res://Scene/wall_shelves.tscn"), price = 150, pos = Vector2(272,-88), bought = false}, #wallshelves
	1 : {scene = preload("res://Scene/stool.tscn"), price = 70, pos = Vector2(-81, 275), bought = false},#stool
	2 : {scene = preload("res://Scene/Laddle.tscn"), price = 300, pos = Vector2(-488, -24), bought = false}, #cauldron
	3 : {scene = preload("res://Scene/clock.tscn"), price = 450, pos = Vector2(322, -207), bought = false}, #clock
	4 : {scene = preload("res://Scene/real_plant.tscn"), price = 120, pos = Vector2(792, 150), bought = false}, #realplant
	5 : {scene = preload("res://Scene/more_plant.tscn"), price = 400, pos = Vector2(70, 445), bought = false} #moreplant
}
var time_of_holding = 0

@onready var sold_sprites = [$Sold/Sprite2D1, $Sold/Sprite2D2, $Sold/Sprite2D3, $Sold/Sprite2D4, $Sold/Sprite2D5, $Sold/Sprite2D6]

func _ready():
	for i in range(upgrade_types.size()):
		if upgrade_types[i].has("price"):
			get_node("Prices/Label" + str(i+1)).text = str(upgrade_types[i].price)

func _process(delta):
	for i in range(upgrade_types.size()):
		if upgrade_types[i].has("price") && upgrade_types[i].bought == false:
			get_node("Colors/red" + str(i+1)).visible = GlobalScript.money <  upgrade_types[i].price
		elif upgrade_types[i].bought == true:
			get_node("Colors/red" + str(i+1)).visible = true
	if isHolding == true:
		time_of_holding += delta
		global_position.x = clamp(get_global_mouse_position().x - movePotPos.x, 685, 1156)

func _on_pull_area_2d_input_event(_viewport, event, _shape_idx):
	if  event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			if at_max == true:
				global_position.x = 1156
				at_max = false
			else:
				isHolding = true
				movePotPos = get_global_mouse_position() - global_position
				oldPotPos = global_position
		else:
			if time_of_holding <= 0.2:
				if global_position.x <= 920:
					global_position.x = 1155
				else:
					global_position.x = 686
			time_of_holding = 0
			isHolding = false

var at_max = false

func _input( event ):
	if event is InputEventMouseButton:
		if event.button_index == 1 and !event.is_pressed():
			isHolding = false
			if global_position.x <= 690:
				at_max = true

func _on_buy_area_2d_input_event(_viewport, event, _shape_idx, i):
	if GlobalScript.isEmpty == true && GlobalScript.money >= upgrade_types[i].price && !upgrade_types[i].bought:
		if  event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
			GlobalScript.money -= upgrade_types[i].price
			var instance = upgrade_types[i].scene.instantiate()
			instance.global_position = upgrade_types[i].pos
			call_deferred("add_sibling", instance)
			upgrade_types[i].bought = true
			sold_sprites[i].visible = true
			
			if i == 2:
				GlobalScript.cauldron = true
