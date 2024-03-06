extends Node2D

var dialogs = {
	#story1
	0: "This place feels so empty...",
	1: "I miss my master...",
	2: "Oh! A human? Haven't seen your 
	kind in a while.",
	3: "They're usually eaten by monsters.",
	4: "If you don't want that, I suggest 
	selling them fresh flesh.",
	5: "Go plant flesh seeds. Quench their 
	thirst for blood.",
	6: "Harvest and sell.",
	#story2
	7: "Good. You can also make potions 
	out of the body parts.",
	8: "Throw 2 crops into the bucket, 
	and stir.",
	9: "You make more money that way.",
	10: "Try making a few more gold (1000G) 
	and fix this place up (Upgrades).",
	#story3
	11: "Pesk angels. Hypocritical beings 
	of heavens.",
	12: "Kill them with that angel spray!",
	#story4
	13: "You can throw 3 crops in the
	 cauldron!",
	#story5
	14: "Good morning.",
	15: "I hope you'll enjoy your stay in 
	the FLESH GARDEN.",
	
	16: ""
}

@onready var label = $Sprite2D/Label
@onready var button = $Sprite2D/Button
@onready var sprite_2d = $Sprite2D

var phase = 0
var story = 1
var done1 = false
var done2 = false
var done3 = false
var done4 = false

func _ready():
	label.text = dialogs[0]

func _process(_delta):
	if GlobalScript.storage[0] >= 1 && GlobalScript.storage[1] >= 1 && done1 == false:
		done1 = true
		phase = 7
		label.text = dialogs[phase]
		sprite_2d.visible = true
	if GlobalScript.time_of_day == 1 && done2 == false:
		done2 = true
		phase = 11
		label.text = dialogs[phase]
		sprite_2d.visible = true
	if GlobalScript.time_of_day == 0 && done3 == false && done2 == true:
		done3 = true
		phase = 14
		label.text = dialogs[phase]
		sprite_2d.visible = true
	if GlobalScript.cauldron && done4 == false:
		print(done4)
		done4 = true
		phase = 13
		label.text = dialogs[phase]
		sprite_2d.visible = true

func _on_button_button_down():
	phase += 1
	label.text = dialogs[phase]
	if phase == 7 || phase == 11:
		sprite_2d.visible = false 
		story += 1
	if  phase == 13 || phase == 14:
		sprite_2d.visible = false
	if phase == 16:
		queue_free()
