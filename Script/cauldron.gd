extends Node2D

var couldron_type= {
	0 : preload("res://Art Assets/Bucket.png"),
	1 : preload("res://Art Assets/Couldron.png"),
}

var crop_types = {
	0: {name = "eyeball", number = 0},
	1: {name = "hands", number = 0},
	2: {name = "leg", number = 0},
	3: {name = "head", number = 0},
	9: {name = "heart", number = 0}
}

var potion_types = {
	0 : preload("res://Scene/potion_1.tscn"), #agility
	1 : preload("res://Scene/potion_2.tscn"), #wisdom
	2 : preload("res://Scene/potion_3.tscn"), #passion
	3 : preload("res://Scene/potion_4.tscn"), #lust
	4 : preload("res://Scene/potion_5.tscn"), #strength
	5 : preload("res://Scene/potion_6.tscn")  #chum
}

@onready var bucket_collisions = [
	$BuckeyStaticBody2D/CollisionShape2D, 
	$BuckeyStaticBody2D/CollisionShape2D2, 
	$BuckeyStaticBody2D/CollisionShape2D3, 
	$BuckeyStaticBody2D/CollisionShape2D4, 
	$BuckeyStaticBody2D/CollisionShape2D5,
	$BucketStaticBody2D2/CollisionShape2D6, 
	$BucketStaticBody2D2/CollisionShape2D7]
	
@onready var couldron_collisions = [
	$StaticBody2D/CollisionShape2D,
	$StaticBody2D/CollisionShape2D2,
	$StaticBody2D/CollisionShape2D3,
	$StaticBody2D/CollisionShape2D4,
	$StaticBody2D/CollisionShape2D5,
	$StaticBody2D3/CollisionShape2D6, 
	$StaticBody2D3/CollisionShape2D7]
	
@onready var falling_area = $FallArea2D/CollisionShape2D
@onready var cauldron_area = $BucketArea2D/CollisionShape2D
@onready var poof = $AudioStreamPlayer2D
@onready var bucket_sfx_1 = $AudioStreamPlayer2D2
@onready var bucket_sfx_2 = $AudioStreamPlayer2D3
@onready var water_splash = $AudioStreamPlayer2D4
@onready var slpash_anim = $AnimationPlayer
@onready var slpash_sprite = $Sprite2D2
@onready var cauldron_sfx_1 = $AudioStreamPlayer2D5
@onready var cauldron_sfx_2 = $AudioStreamPlayer2D6


func _ready():
	for shape in couldron_collisions:
		shape.disabled = true
	slpash_sprite.visible = false

func _process(_delta):
	# for upgrade
	if GlobalScript.cauldron == true:
		$Sprite2D.texture = couldron_type[1]
		for shape in bucket_collisions:
			shape.disabled = true
		for shape in couldron_collisions:
			shape.disabled = false
		slpash_sprite.position.y = -227
	
	# for fall area
	if crop_cauldron >= 2 && GlobalScript.cauldron == false:
		falling_area.disabled = true
		cauldron_area.disabled = true
	elif crop_cauldron >= 3 && GlobalScript.cauldron == true:
		falling_area.disabled = true
		cauldron_area.disabled = true
	else:
		falling_area.disabled = false
		cauldron_area.disabled = false

	# for no of crops in side
	mixing_two()
	mixing_three()

func mixing_two():
	if crop_cauldron == 2 && stir >= 7:
		if crop_types[1].number == 1 && crop_types[2].number == 1:
			var instance = potion_types[0].instantiate() #agility
			instance.position = Vector2(-476,-30)
			call_deferred("add_sibling", instance)
		elif crop_types[3].number == 1 && (crop_types[0].number == 1 || crop_types[1].number == 1):
			var instance = potion_types[1].instantiate() #wisdom
			instance.position = Vector2(-476,-30)
			call_deferred("add_sibling", instance)
		elif crop_types[0].number == 1 && (crop_types[1].number == 1 || crop_types[9].number == 1):
			var instance = potion_types[3].instantiate() #passion
			instance.position = Vector2(-476,-30)
			call_deferred("add_sibling", instance)
		else:
			var instance = potion_types[5].instantiate() #chum
			instance.position = Vector2(-476,-30)
			call_deferred("add_sibling", instance)
		for i in crop_types:
			crop_types[i].number = 0
		crop_cauldron = 0
		stir = 0
		poof.play()
		in_the_cauldron[0].name = "pop"
		in_the_cauldron[1].name = "pop"

func mixing_three():
	if crop_cauldron == 3 && stir >= 7:
		if (crop_types[1].number == 1 && crop_types[3].number == 1 && crop_types[9].number == 1):
			var instance = potion_types[2].instantiate() #lust
			instance.position = Vector2(-476,-30)
			call_deferred("add_sibling", instance)
		elif (crop_types[0].number == 1 && crop_types[2].number == 1 && crop_types[9].number == 1) || (crop_types[1].number == 1 && crop_types[2].number == 1 && crop_types[3].number == 1):
			var instance = potion_types[4].instantiate() #strength
			instance.position = Vector2(-476,-30)
			call_deferred("add_sibling", instance)
		else:
			var instance = potion_types[5].instantiate() #chum
			instance.position = Vector2(-476,-30)
			call_deferred("add_sibling", instance)
			
		for i in crop_types:
			crop_types[i].number = 0
		crop_cauldron = 0
		stir = 0
		poof.play()
		in_the_cauldron[0].name = "pop"
		in_the_cauldron[1].name = "pop"

var crop_cauldron = 0
var stir = 0


func _on_bucket_area_2d_area_entered(area):
	if area.is_in_group(in_the_cauldron[0].name) || area.is_in_group(in_the_cauldron[1].name):
		GlobalScript.is_cauldron_area = true
	else:
		for i in crop_types:
			if area.is_in_group(crop_types[i].name):
				water_splash.play()
				crop_cauldron += 1
				crop_types[i].number += 1
				GlobalScript.storage[i] -= 1
				slpash_sprite.visible = true
				slpash_anim.play("splash")
				if crop_cauldron ==  1:
					in_the_cauldron[0]["name"] = crop_types[i]["name"]
				if crop_cauldron ==  2:
					in_the_cauldron[1]["name"] = crop_types[i]["name"]

func _on_bucket_area_2d_area_exited(area):
	if area.is_in_group(in_the_cauldron[0].name) || area.is_in_group(in_the_cauldron[1].name):
		GlobalScript.is_cauldron_area = false

var in_the_cauldron = {
	0: {"name": "pop"},
	1: {"name": "pop"}
}
func _on_fall_area_2d_area_entered(area):
	if area.is_in_group(in_the_cauldron[0].name) || area.is_in_group(in_the_cauldron[1].name):
		falling_area.call_deferred("set_disabled", true)

func _on_fall_area_2d_area_exited(area):
	if area.is_in_group(in_the_cauldron[0].name) || area.is_in_group(in_the_cauldron[1].name):
		falling_area.call_deferred("set_disabled", false)

func _on_area_2d_area_entered(area):
	if area.is_in_group("laddle"):
		if GlobalScript.cauldron == false:
			bucket_sfx_1.play()
		else:
			cauldron_sfx_1.play()
		if crop_cauldron >= 2:
			stir += 1

func _on_area_2d_2_area_entered(area):
	if area.is_in_group("laddle"):
		if GlobalScript.cauldron == false:
			bucket_sfx_2.play()
		else:
			cauldron_sfx_1.play()
		if crop_cauldron >= 2:
			stir += 1




