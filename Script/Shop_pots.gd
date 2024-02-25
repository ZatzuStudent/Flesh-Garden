extends Node2D

var isHolding
var oldPotPos
var movePotPos
var upgrade_types = {
	0 : {scene = preload("res://Scene/pot_small_1.tscn"), price = 30}, #pot_small
	1 : {scene = preload("res://Scene/pot_big_1.tscn"), price = 50},#pot_big
	2 : {scene = preload("res://Scene/Pot_Hanging_1.tscn"), price = 70}, #pot_hang
	3 : {scene = preload("res://Scene/pot_small_2.tscn"), price = 50}, #pot_small
	4 : {scene = preload("res://Scene/pot_big_2.tscn"), price = 80},#pot_big
	5 : {scene = preload("res://Scene/Pot_Hanging_2.tscn"), price = 120}, #pot_hang
	6 : {scene = preload("res://Scene/pot_small_3.tscn"), price = 100}, #pot_small
	7 : {scene = preload("res://Scene/pot_big_3.tscn"), price = 130},#pot_big
	8 : {scene = preload("res://Scene/Pot_Hanging_3.tscn"), price = 230}, #pot_hang
}
func _ready():
	for i in range(upgrade_types.size()):
		if upgrade_types[i].has("price"):
			get_node("Prices/Label" + str(i+1)).text = str(upgrade_types[i].price)
			
func _process(_delta):
	for i in range(upgrade_types.size()):
		if upgrade_types[i].has("price"):
			get_node("Colors/red" + str(i+1)).visible = GlobalScript.money < upgrade_types[i].price
		
	if isHolding == true:
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
			isHolding = false

var at_max = false

func _input( event ):
	if event is InputEventMouseButton:
		if event.button_index == 1 and !event.is_pressed():
			isHolding = false
			if global_position.x <= 690:
				at_max = true

func _on_buy_area_2d_input_event(_viewport, event, _shape_idx, i):
	if GlobalScript.isEmpty == true && GlobalScript.money >= upgrade_types[i].price:
		if  event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
			GlobalScript.money -= upgrade_types[i].price
			var instance = upgrade_types[i].scene.instantiate()
			call_deferred("add_sibling", instance)
			global_position.x = 1156
