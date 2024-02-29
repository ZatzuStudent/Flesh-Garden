extends Node2D

@onready var frog_label = $FrogLabel
@onready var blood_label = $BloodLabel3
@onready var pots_label = $PotsLabel4
@onready var pull_label = $PullLabel
var done_numbers = {
	0 : 0,
	1 : 0,
	2 : 0,
	3 : 0,
	4 : 0,
}

func _ready():
	pull_label.visible = true
	frog_label.visible = false
	blood_label.visible = false
	pots_label.visible = false

func _on_area_2d_2_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton && event.button_index == 1:
		if event.is_pressed():
			pots_label.visible = true
			pull_label.visible = false
			done_numbers[0] = 1

func _on_area_2d_1_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton && event.button_index == 1:
		if event.is_pressed():
			frog_label.visible = true
			pull_label.visible = false
			done_numbers[1] = 1

func _on_area_2d_3_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton && event.button_index == 1:
		if event.is_pressed():
			frog_label.visible = false
			done_numbers[2] = 1

func _on_area_2d_5_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton && event.button_index == 1:
		if event.is_pressed():
			blood_label.visible = true
			pots_label.visible = true
			done_numbers[3] = 1

func _on_area_2d_4_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton && event.button_index == 1:
		if event.is_pressed():
			blood_label.visible = false
			pots_label.visible = false
			done_numbers[4] = 1

func _process(_delta):
	var done = true
	for i in done_numbers:
		if !done_numbers[i] == 1:
			done = false
			break
	if done == true:
		print('done')
		queue_free()

