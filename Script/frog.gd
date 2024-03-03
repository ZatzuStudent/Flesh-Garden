extends Node2D

var frog_sprite = {
	0 : preload("res://Art Assets/Frog_1.png"), #normal
	1 : preload("res://Art Assets/Frog_3.png"), #gulp
	2 : preload("res://Art Assets/Frog_2.png") #eat
}
var area_to_eat = ["seeds","pots","potions"]
var potion_types = {
	1: {name = "agility", sprite = preload("res://Art Assets/Frog_Potion_1.png")}, 
	2: {name = "wisdom", sprite = preload("res://Art Assets/Frog_Potion_2.png")},
	3: {name = "passion", sprite = preload("res://Art Assets/Frog_Potion_3.png")}, 
	4: {name = "lust", sprite = preload("res://Art Assets/Frog_Potion_4.png")},
	5: {name = "strength", sprite = preload("res://Art Assets/Frog_Potion_5.png")},
	6: {name = "chum", sprite = preload("res://Art Assets/Frog_1.png")}}

@onready var frog_croak = $AudioStreamPlayer2D
@onready var hunger_bar = $ProgressBar
@onready var frog = $"Texture Node/Sprite2D"
@onready var gulp_sfx = $AudioStreamPlayer2D4
@onready var puffing_anim = $Puff2
@onready var puff_sfx = $AudioStreamPlayer2D3
@onready var pink = $"Texture Node/Sprite2D2"
@onready var frog_collision = $Area2D/CollisionShape2D
@onready var shiver_anim = $AnimationPlayer
@onready var frog_hungry = $AudioStreamPlayer2D2

var pressed = false
var type_to_eat = 0
var potion_took = 6
var isEat



func _ready():
	isEat = false

func _process(delta):
	if GlobalScript.paused == false:
		hunger_bar.value -= delta*60
	else:
		hunger_bar.value = hunger_bar.value

	if hunger_bar.value <= 10 && frog_hungry.is_playing() == false && GlobalScript.paused == false:
		shiver_anim.play("tremble")
		frog_hungry.play()
		pink.visible = true
		frog.texture = potion_types[potion_took].sprite
	elif (hunger_bar.value > 10 && frog_hungry.is_playing() == true) || GlobalScript.paused == true:
		shiver_anim.stop()
		frog_hungry.stop()
		pink.visible = false
		frog.texture = potion_types[potion_took].sprite
	

	scale.x = .3+((hunger_bar.value)*.0035)

func _on_area_2d_area_entered(area):
	for i in area_to_eat:
		if area.is_in_group(i):
			frog.texture = frog_sprite[2]
			pink.visible = true
			isEat = true
			if i == "seeds":
				type_to_eat = 1
			elif i == "pots":
				type_to_eat = 2
			elif i == "potions":
				type_to_eat = 3
	for i in potion_types:
		if area.is_in_group(potion_types[i].name):
			potion_took = i

func _on_area_2d_area_exited(area):
	for i in area_to_eat:
		if area.is_in_group(i):
			pink.visible = false
			isEat = false
			potion_took = 6
			
			if type_to_eat != 3:
				frog.texture = frog_sprite[0]
			elif pressed == true:
				frog.texture = frog_sprite[0]
			type_to_eat = 0

func _on_area_2d_input_event(_viewport, event, _shape_idx):
	if  event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			pressed = true
			frog.texture = frog_sprite[1]
			await get_tree().create_timer(.3).timeout
			frog.texture = frog_sprite[0]
			frog_croak.play()

func _input(event):
	if  event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
		if !event.pressed:
			pressed = false
			if type_to_eat == 1:
				hunger_bar.value += 30
				gulp_sfx.play()
			elif type_to_eat == 2:
				hunger_bar.value += 100
				gulp_sfx.play()
			elif type_to_eat == 3:
				hunger_bar.value += 200
				gulp_sfx.play()
				
				puffing_anim.play("Puff")
				puff_sfx.play()
				print(potion_took)
				print('joj')
				frog.texture = potion_types[potion_took].sprite
				await get_tree().create_timer(.1).timeout
				frog_collision.disabled = true
				await get_tree().create_timer(3.0).timeout
				potion_took = 6
				puffing_anim.play("Puff")
				puff_sfx.play()
				frog.texture = frog_sprite[0]
				frog_collision.disabled = false
