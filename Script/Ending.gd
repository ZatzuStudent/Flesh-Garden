extends Node2D

@onready var ending_anim = $AnimationPlayer
@onready var sprite_2d = $Sprite2D
@onready var sprite_2d_2 = $Sprite2D2
var ending = false
var phase = 1
func _ready():
	sprite_2d.visible = false
	sprite_2d_2.visible = false
	

func _process(_delta):
	if GlobalScript.all_bought == true && GlobalScript.money >= 1000 && sprite_2d.visible == false:
		if ending == false:
			GlobalScript.shop_open = 4
			ending = true
			ending_anim.play("Ending")
			await ending_anim.animation_finished
			phase = 2

func _input(event):
	if  event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed:
			if phase == 2:
				ending_anim.play("Ending2")
				await ending_anim.animation_finished
				phase = 3
			elif phase == 3:
				ending_anim.play("Ending3")
				await ending_anim.animation_finished
				queue_free()
