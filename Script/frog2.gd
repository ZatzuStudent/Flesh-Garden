extends Node2D

var frog_sprite = {
	0 : preload("res://Art Assets/Frog_1.png"), #normal
	1 : preload("res://Art Assets/Frog_3.png"), #gulp
	2 : preload("res://Art Assets/Frog_2.png") #eat
}
var area_to_eat = {
	0 : {name = "seeds"},
	1 : {name = "pots"},
	2 : {name = "potions"}}

var potion_types = {
	1: {name = "agility", sprite = preload("res://Art Assets/Frog_Potion_1.png")}, 
	2: {name = "wisdom", sprite = preload("res://Art Assets/Frog_Potion_2.png")},
	3: {name = "passion", sprite = preload("res://Art Assets/Frog_Potion_3.png")}, 
	4: {name = "lust", sprite = preload("res://Art Assets/Frog_Potion_4.png")},
	5: {name = "strength", sprite = preload("res://Art Assets/Frog_Potion_5.png")},
	6: {name = "chum", sprite = preload("res://Art Assets/Frog_1.png")}}

@onready var click_sfx = $AudioStreamPlayer2D
@onready var poof_sfx = $AudioStreamPlayer2D3
@onready var gulp_sfx = $AudioStreamPlayer2D4
@onready var pink = $"Texture Node/Pink"
@onready var frog = $"Texture Node/Frog"
@onready var puff_anim = $Puff_anim
@onready var eat_collision = $Area2D/CollisionShape2D

var isPressing = false

func _ready():
	frog.texture = frog_sprite[0]

func _on_area_2d_input_event(_viewport, event, _shape_idx):
	if  event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed && transforming == false:
			frog.texture = frog_sprite[1]
			await get_tree().create_timer(.3).timeout
			frog.texture = frog_sprite[0]
			click_sfx.play()

var croptype = null
var type_of_food = null

func _input(event):
	if  event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			isPressing = true
		elif transforming == false:
			isPressing = false
			if type_of_food != null:
				gulp_sfx.play()
				type_of_food = null
			if croptype != null:
				GlobalScript.storage[croptype] -= 1
				gulp_sfx.play()

var crop_storage = {
	0: "eyeball", #eyeball
	1: "hands", #hand
	2: "leg", #leg
	3: "head", #head
	9: "heart"}


func _on_area_2d_area_entered(area):
	for i in area_to_eat:
		if area.is_in_group(area_to_eat[i].name):
			frog.texture = frog_sprite[2]
			type_of_food = i
	for i in crop_storage:
		if area.is_in_group(crop_storage[i]):
			frog.texture = frog_sprite[2]
			croptype = i

func _on_area_2d_area_exited(area):
	for i in area_to_eat:
		if area.is_in_group(area_to_eat[i].name):
			frog.texture = frog_sprite[0]
			type_of_food = null
	for i in crop_storage:
		if area.is_in_group(crop_storage[i]):
			frog.texture = frog_sprite[0]
			croptype = null
	
	for i in potion_types:
		if i != 6:
			if area.is_in_group(potion_types[i].name) && isPressing == false:
				frog.texture = potion_types[i].sprite
				_transform()

var transforming = false

func _transform():
	puff_anim.play("Puff")
	poof_sfx.play()
	frog.z_index = 50
	await get_tree().create_timer(.1).timeout
	eat_collision.disabled = true
	pink.visible = false
	transforming = true
	await get_tree().create_timer(3.0).timeout
	frog.z_index = 0
	puff_anim.play("Puff")
	
	frog.texture = frog_sprite[0]
	eat_collision.disabled = false
	pink.visible = true
	transforming = false
