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
	4 : preload("res://Art Assets/Potions Colored_2.png"),#agility
	5 : preload("res://Art Assets/Potions Colored_4.png"),#wisdom
	6 : preload("res://Art Assets/Potions Colored_1.png"),#strength

	7 : preload("res://Art Assets/Potions Colored_0.png"),#passion
	8 : preload("res://Art Assets/Potions Colored_3.png"),#lust
	9 : preload("res://Art Assets/Growth/Plant Growth Spite_22.png"),#heart
}

var parts = ["eyeball", "hands", "leg", "head","agility","wisdom","strength","passion", "lust", "heart"]
var part_numbers = {0:0, 1:0, 2:0, 3:0, 4:0, 5:0, 6:0, 7:0, 8:0, 9:0}
var part_price = {
	0: 2,
	1: 5, 
	2: 30, 
	3: 150, 
	4: 50,
	5: 100,
	6: 250, 
	7: 250, 
	8: 250, 
	9: 25}

@onready var animation_player = $"../AnimationPlayer"
@onready var crop_sprite = $"../DialogSprite2D1/CropSprite2D1"
@onready var required_label = $"../DialogSprite2D1/RequiredLabel"
@onready var sprite_2d = $"../Sprite2D"
@onready var dialog_sprite = $"../DialogSprite2D1"
@onready var collision_req = $"../Area2D/CollisionShape2D"
@onready var next_time_but = $"../Button2"
@onready var kaching_sfx = $"../AudioStreamPlayer2D"
@onready var seller_area = $"../potionArea2D/CollisionShape2D"

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
	next_time_but.modulate = Color(1,1,1,.2)
	dialog_sprite.visible = false
	next_time_but.visible = false
	seller_area.call_deferred("set_disabled", true)
	sprite_2d.texture = customer_type[GlobalScript.customer_number]
	customer_sfx[GlobalScript.customer_number].play()
	animation_player.play("walk_in")
	collision_req.disabled = true
	await animation_player.animation_finished
	dialog_sprite.visible = true
	next_time_but.visible = true
	collision_req.disabled = false
	if GlobalScript.customer_number == 2:
		$"../Sprite2D".z_index = 3
	customer_old = GlobalScript.customer_number
	if GlobalScript.day >= 10:
		required_type_harvest = randi_range(0,9)
	else:
		required_type_harvest = randi_range(0,5)
	if 4 <= required_type_harvest || required_type_harvest >= 8:
		required_number_harvest = 1
	elif required_type_harvest == 0:
		required_number_harvest = randi_range(7,15)
	elif required_type_harvest == 3:
		required_number_harvest = randi_range(1,3)
	else: 
		required_number_harvest = randi_range(1,7)
	
	part_numbers[required_type_harvest] = required_number_harvest
	required_label.text = str(required_number_harvest)
	crop_sprite.texture = crop_type[required_type_harvest]

func _process(_delta):
	if GlobalScript.ClockTimer <= ((GlobalScript.timePerday)/2)-10:
		while true:
			customer_new = randi_range(0,  4)
			if customer_new != GlobalScript.customer_number:
				GlobalScript.customer_number = customer_new
				break
		dialog_sprite.visible = false
		next_time_but.visible = false
		animation_player.play("walk_out")
		collision_req.disabled = true
		await animation_player.animation_finished
		$"..".queue_free()

func _input( event ):
	if event is InputEventMouseButton:
		if event.button_index == 1 && !event.is_pressed():
			if inSeller == true:
				if GlobalScript.storage[required_type_harvest] >= part_numbers[required_type_harvest]:
					GlobalScript.storage[required_type_harvest] = GlobalScript.storage[required_type_harvest]-required_number_harvest
					GlobalScript.money += required_number_harvest*part_price[required_type_harvest]
					GlobalScript.customer_love[GlobalScript.customer_number] += 1
					kaching_sfx.play()
					_to_exit()


func _on_area_2d_area_entered(area):
	if area.is_in_group(parts[required_type_harvest]):
		inSeller = true
		seller_area.call_deferred("set_disabled", false)
	return
		
func _on_area_2d_area_exited(area):
	if area.is_in_group(parts[required_type_harvest]):
		inSeller = false
		seller_area.call_deferred("set_disabled", true)
	return

func _on_button_2_button_down():
	_to_exit()

func _to_exit():
	while true:
		customer_new = randi_range(0,  4)
		if customer_new != GlobalScript.customer_number:
			GlobalScript.customer_number = customer_new
			break
	dialog_sprite.visible = false
	next_time_but.visible = false
	$"../Sprite2D".z_index = -9
	animation_player.play("walk_out")
	collision_req.disabled = true
	await animation_player.animation_finished
	$"..".queue_free()

func _on_button_2_mouse_entered():
	next_time_but.modulate = Color(1,1,1,1)

func _on_button_2_mouse_exited():
	next_time_but.modulate = Color(1,1,1,.2)
