extends Node2D

var isHolding
var oldPotPos
var movePotPos
var upgrade_types = {
	0 : {scene = preload("res://Scene/pot_small_1.tscn"), price = 30}, #pot_small
	1 : {scene = preload("res://Scene/pot_big_1.tscn"), price = 50},#pot_big
	2 : {scene = preload("res://Scene/Pot_Hanging_1.tscn"), price = 40}, #pot_hang
	3 : {scene = preload("res://Scene/pot_small_2.tscn"), price = 50}, #pot_small
	4 : {scene = preload("res://Scene/pot_big_2.tscn"), price = 80},#pot_big
	5 : {scene = preload("res://Scene/Pot_Hanging_2.tscn"), price = 60}, #pot_hang
	6 : {scene = preload("res://Scene/pot_small_3.tscn"), price = 100}, #pot_small
	7 : {scene = preload("res://Scene/pot_big_3.tscn"), price = 230},#pot_big
	8 : {scene = preload("res://Scene/Pot_Hanging_3.tscn"), price = 180}, #pot_hang
}
@onready var pull_coll = $PullArea2D/CollisionShape2D

var spawn_node = preload("res://Scene/just_spawned.tscn")
var time_of_holding = 0
var spawn_in_shop = 0

func _ready():
	for i in range(upgrade_types.size()):
		if upgrade_types[i].has("price"):
			get_node("Prices/Label" + str(i+1)).text = str(upgrade_types[i].price)

func _process(delta):
	if GlobalScript.shop_open != 2:
		global_position.x = 1155
	for i in range(upgrade_types.size()):
		if upgrade_types[i].has("price"):
			get_node("Colors/red" + str(i+1)).visible = GlobalScript.money < upgrade_types[i].price
	if isHolding == true:
		time_of_holding += delta
		global_position.x = clamp(get_global_mouse_position().x - movePotPos.x, 685, 1155)
	if spawn_in_shop == 0:
		$BuyAreas.visible = true
	else:
		$BuyAreas.visible = false

func _on_pull_area_2d_input_event(_viewport, event, _shape_idx):
	if  event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
		GlobalScript.shop_open = 2
		if event.pressed:
			isHolding = true
			movePotPos = get_global_mouse_position() - global_position
			oldPotPos = global_position
		else:
			if time_of_holding <= 0.2 && time_of_holding > 0:
				if global_position.x <= 920:
					global_position.x = 1155
				else:
					global_position.x = 686
			time_of_holding = 0

func _input( event ):
	if event is InputEventMouseButton:
		if event.button_index == 1 and !event.is_pressed():
			isHolding = false

func _on_buy_area_2d_input_event(_viewport, event, _shape_idx, i):
	if GlobalScript.money >= upgrade_types[i].price:
		if  event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
			GlobalScript.money -= upgrade_types[i].price
			var instance = upgrade_types[i].scene.instantiate()
			call_deferred("add_sibling", instance)
			var instance2 = spawn_node.instantiate()
			call_deferred("add_sibling", instance2)
			global_position.x = 1155

var shop_overlap = false

func _on_buy_area_2d_1_area_entered(area):
	if area.is_in_group("just_spawn"):
		spawn_in_shop += 1

func _on_buy_area_2d_1_area_exited(area):
	if area.is_in_group("just_spawn"):
		spawn_in_shop -= 1

func _on_pull_area_2d_area_entered(area):
	if area.is_in_group("shops"):
		pull_coll.set_deferred("disabled", true)

func _on_pull_area_2d_area_exited(area):
	if area.is_in_group("shops"):
		await get_tree().create_timer(.3).timeout
		pull_coll.set_deferred("disabled", false)
