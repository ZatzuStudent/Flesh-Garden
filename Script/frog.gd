extends Node2D

var frog_sprite = {
	0 : preload("res://Art Assets/Frog_1.png"), #normal
	1 : preload("res://Art Assets/Frog_2.png"), #gulp
	2 : preload("res://Art Assets/Frog_3.png") #open
}
@onready var frog_croak = $AudioStreamPlayer2D

var isEat

func _ready():
	isEat = false

func _process(_delta):
	if GlobalScript.frog_eaten == 5:
		scale = scale*1.1
		GlobalScript.frog_size += 1
		GlobalScript.frog_eaten = 0
	if GlobalScript.frog_size == 0:
		scale = Vector2(1,1)
		
var area_to_eat = ["seeds","pots","potions"]

func _on_area_2d_area_entered(area):
	for i in area_to_eat:
		if area.is_in_group(i):
			$Sprite2D.texture = frog_sprite[2]
			isEat = true

func _on_area_2d_area_exited(area):
	for i in area_to_eat:
		if area.is_in_group(i):
			$Sprite2D.texture = frog_sprite[1]
			isEat = false

var unpress
func _on_area_2d_input_event(_viewport, event, _shape_idx):
	if  event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed:
			frog_croak.play()
			$Sprite2D.texture = frog_sprite[1]
			await get_tree().create_timer(.3).timeout
			$Sprite2D.texture = frog_sprite[0]
