extends Node2D

@onready var frog_label = $FrogLabel
@onready var blood_label = $BloodLabel3
@onready var pots_label = $PotsLabel4
@onready var pull_label = $PullLabel
@onready var tutorial_anim = $AnimationPlayer

var done_numbers = {
	0 : 0,
	1 : 0,
	2 : 0,
	3 : 0,
	4 : 0,
}

func _ready():
	pull_label.modulate = Color(1,1,1,1)
	frog_label.modulate = Color(1,1,1,0)
	blood_label.modulate = Color(1,1,1,0)
	pots_label.modulate = Color(1,1,1,0)

func _pot_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton && event.button_index == 1:
		if event.is_pressed() && done_numbers[0] == 0:
			pots_label.modulate = Color(1,1,1,1)
			done_numbers[0] = 1
			if pull == false:
				tutorial_anim.play("pull")
				pull = true

var pot = false
var pull = false


func _seed_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton && event.button_index == 1:
		if event.is_pressed() && done_numbers[1] == 0:
			frog_label.modulate = Color(1,1,1,1)
			done_numbers[1] = 1
			if pull == false:
				tutorial_anim.play("pull")
				pull = true

func _frog_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton && event.button_index == 1:
		if done_numbers[2] == 0 && frog_label.modulate == Color(1,1,1,1):
			if event.is_pressed():
				done_numbers[2] = 1
				tutorial_anim.play("frog")
			else:
				done_numbers[2] = 1
				tutorial_anim.play("frog")
				

func _table_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton && event.button_index == 1:
		if event.is_pressed() && done_numbers[3] == 0:
			blood_label.modulate = Color(1,1,1,1)
			done_numbers[3] = 1
			if pot == false:
				tutorial_anim.play("pot")
				pot = true

func _pot2_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton && event.button_index == 1:
		if event.is_pressed() && pot == false:
			tutorial_anim.play("pot")
			pot = true

func _blood_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton && event.button_index == 1:
		if event.is_pressed() && done_numbers[4] == 0 && blood_label.modulate == Color(1,1,1,1):
			blood_label.modulate = Color(1,1,1,0)
			tutorial_anim.play("blood")
			done_numbers[4] = 1

func _process(_delta):
	var done = true
	for i in done_numbers:
		if !done_numbers[i] == 1:
			done = false
			break
	if done == true:
		await tutorial_anim.animation_finished
		queue_free()


