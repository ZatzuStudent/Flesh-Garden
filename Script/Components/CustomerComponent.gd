extends Node2D

var customer_type = {
	0 : preload("res://Art Assets/Customer_Bird.png"),
	1 : preload("res://Art Assets/Customer_Brain.png"),
	2 : preload("res://Art Assets/Customer_Mushroom.png"),
	3 : preload("res://Art Assets/Customer_Nobody.png"),
	4 : preload("res://Art Assets/Customer_Skeleton.png")
}

var crop_type= {
	0 : preload("res://Art Assets/Growth/Plant Growth Spite_23.png"),#eye
	1 : preload("res://Art Assets/Growth/Plant Growth Spite_24.png"),#hand
	2 : preload("res://Art Assets/Growth/Plant Growth Spite_26.png"),#leg
	3 : preload("res://Art Assets/Growth/Plant Growth Spite_25.png"),#skull
	4 : preload("res://Art Assets/Potions Colored_2.png"),#0 agility 2
	5 : preload("res://Art Assets/Potions Colored_4.png"),#1 wisdom 3
	6 : preload("res://Art Assets/Potions Colored_1.png"),#4 strength 3

	7 : preload("res://Art Assets/Potions Colored_0.png"),# 2 passion 4
	8 : preload("res://Art Assets/Potions Colored_3.png"),# 3 lust 1
	9 : preload("res://Art Assets/Growth/Plant Growth Spite_22.png"),#heart
}

var parts = ["eyeball", "hands", "leg", "head","agility","wisdom","strength","passion", "lust", "heart"]

var potions_types = {
	4 : "agility",
	5 : "wisdom",
	6 : "strength",
	7 : "passion",
	8 : "lust"}

var part_numbers = {0:0, 1:0, 2:0, 3:0, 4:0, 5:0, 6:0, 7:0, 8:0, 9:0}
var part_price = {
	0: 4, #eye 4x3x3 = 36
	1: 7, #hand 6x3x2 = 36
	2: 20, #leg x4
	3: 50, #skull x3
	4: 90, #agility 35 
	5: 150, #wisdom 52
	6: 250,# strength 72 or 85
	7: 160, #passion 57
	8: 45, #lust 7 45
	9: 25} #heart

@onready var animation_player = $"../AnimationPlayer"
@onready var crop_sprite = $"../DialogSprite2D1/CropSprite2D1"
@onready var required_label = $"../DialogSprite2D1/RequiredLabel"
@onready var sprite_2d = $"../Sprite2D"
@onready var dialog_sprite = $"../DialogSprite2D1"
@onready var collision_req = $"../Area2D/CollisionShape2D"
@onready var collision_req2 = $"../Area2D/CollisionShape2D2"
@onready var next_time_but = $"../Button2"
@onready var kaching_sfx = $"../AudioStreamPlayer2D"
@onready var seller_area = $"../potionArea2D/CollisionShape2D"
@onready var seller_area2 = $"../potionArea2D/CollisionShape2D3"
@onready var plus_money_anim = $"../Float Plus Money/AnimationPlayer"
@onready var plus_money_label = $"../Float Plus Money/Label"
@onready var float_plus_node = $"../Float Plus Money"
var holding_right = false

@onready var customer_sfx = [
	$"../sfx/AudioStreamPlayer2D1", 
	$"../sfx/AudioStreamPlayer2D2", 
	$"../sfx/AudioStreamPlayer2D3", 
	$"../sfx/AudioStreamPlayer2D4", 
	$"../sfx/AudioStreamPlayer2D5"]

var required_number_harvest
var required_type_harvest
var required_harvest
var inSeller
var customer_new
var customer_old

func _ready():
	sprite_2d.z_index = -101
	seller_area.call_deferred("set_disabled", true)
	seller_area2.call_deferred("set_disabled", true)
	sprite_2d.visible = false
	dialog_sprite.visible = false
	next_time_but.visible = false
	float_plus_node.visible = false
	collision_req.disabled = true
	collision_req2.disabled = true
	await get_tree().create_timer(randi_range(6,15)).timeout
	next_time_but.modulate = Color(1,1,1,.2)
	sprite_2d.texture = customer_type[GlobalScript.customer_number]
	customer_sfx[GlobalScript.customer_number].play()
	sprite_2d.visible = true
	animation_player.play("walk_in")
	await animation_player.animation_finished
	dialog_sprite.visible = true
	next_time_but.visible = true
	collision_req.disabled = false
	collision_req2.disabled = false
	
	if GlobalScript.customer_number == 2:
		sprite_2d.z_index = -89

	customer_old = GlobalScript.customer_number
	required_type_harvest = GlobalScript.crop_numbers[randi_range(0, GlobalScript.crop_numbers.size() -  1)]
	
	_check_if_available()
	_number_harvest()

	if required_type_harvest != null:
		part_numbers[required_type_harvest] = required_number_harvest
		required_label.text = str(required_number_harvest)
		crop_sprite.texture = crop_type[required_type_harvest]

func _process(_delta):
	if GlobalScript.time_of_day == 1:
		_to_exit()
	_to_open_potion_sell()

func _input( event ):
	if event is InputEventMouseButton && event.button_index == 1:
		if !event.is_pressed():
			if inSeller == true && holding_right == true:
				if GlobalScript.storage[required_type_harvest] >= part_numbers[required_type_harvest]:
					_to_be_sold()

func _to_be_sold():
	GlobalScript.storage[required_type_harvest] = GlobalScript.storage[required_type_harvest]-required_number_harvest
	GlobalScript.money += required_number_harvest*part_price[required_type_harvest]
	plus_money_label.text = '+' + str(required_number_harvest*part_price[required_type_harvest])
	GlobalScript.customer_love[GlobalScript.customer_number] += 1
	kaching_sfx.play()
	float_plus_node.visible = true
	plus_money_anim.play("float_money")
	_to_exit()

var potion_needed = 0



func _on_button_2_button_down():
	_to_exit()

func _on_button_2_mouse_entered():
	next_time_but.modulate = Color(1,1,1,1)

func _on_button_2_mouse_exited():
	next_time_but.modulate = Color(1,1,1,.2)

func _on_potion_holder_area_entered(area):
	if required_type_harvest != null:
		if area.is_in_group(parts[required_type_harvest]):
			holding_right = true
			
func _on_potion_holder_area_exited(area):
	if required_type_harvest != null:
		if area.is_in_group(parts[required_type_harvest]):
			holding_right = false
			
func _on_area_2d_area_entered(area):
	if required_type_harvest != null:
		if area.is_in_group("potion_hold_area"):
			inSeller = true
			
func _on_area_2d_area_exited(area):
	if required_type_harvest != null:
		if area.is_in_group("potion_hold_area"):
			inSeller = false

func _to_open_potion_sell():
	if holding_right == true && inSeller == true:
		seller_area.call_deferred("set_disabled", false)
		seller_area2.call_deferred("set_disabled", false)
	else:
		seller_area.call_deferred("set_disabled", true)
		seller_area2.call_deferred("set_disabled", true)

#ALL FUNCS

func _to_exit():
	while true:
		customer_new = randi_range(0, 4)
		if customer_new != GlobalScript.customer_number:
			GlobalScript.customer_number = customer_new
			break
	dialog_sprite.visible = false
	next_time_but.visible = false
	sprite_2d.z_index = -101
	animation_player.play("walk_out")
	collision_req.disabled = true
	collision_req2.disabled = true
	await animation_player.animation_finished
	$"..".queue_free()

func _check_if_available():
	if GlobalScript.storage[2] >= 1 && !GlobalScript.crop_numbers.has(2):
		GlobalScript.crop_numbers.append(2)
		GlobalScript.crop_numbers.append(4)
	if GlobalScript.storage[3] >= 1 && !GlobalScript.crop_numbers.has(3):
		GlobalScript.crop_numbers.append(3)
		GlobalScript.crop_numbers.append(5)
	if GlobalScript.storage[9] >= 1 && !GlobalScript.crop_numbers.has(9):
		GlobalScript.crop_numbers.append(9)
	if GlobalScript.cauldron == true:
		if GlobalScript.storage[3] >= 1:
			GlobalScript.crop_numbers.append(6)
		if GlobalScript.storage[9] >= 1:
			GlobalScript.crop_numbers.append(7)

func _number_harvest():
	if required_type_harvest != null:
		if required_type_harvest == 0:
			if GlobalScript.day >= 3:
				required_number_harvest = randi_range(6,20)
			elif GlobalScript.day == 2:
				required_number_harvest = randi_range(6,12)
			elif GlobalScript.day <= 1:
				required_number_harvest = randi_range(1,5)
		elif required_type_harvest == 1:
			if GlobalScript.day >= 3:
				required_number_harvest = randi_range(3,15)
			elif GlobalScript.day <= 2:
				required_number_harvest = randi_range(1,5)
		elif required_type_harvest == 2:
			required_number_harvest = randi_range(2,6)
		elif required_type_harvest == 3:
			required_number_harvest = randi_range(1,3)
		elif required_type_harvest == 9:
			required_number_harvest = randi_range(2,6)
		else:
			required_number_harvest = 1



