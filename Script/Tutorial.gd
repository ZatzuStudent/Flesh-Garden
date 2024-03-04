extends Node2D

@onready var animation_player = $AnimationPlayer
@onready var tutorial = $"."
var onTutor = false

func _ready():
	tutorial.visible = false


func _process(_delta):
	if GlobalScript.storage[0] >= 1 && GlobalScript.storage[1] >= 1 && onTutor == false: 
		onTutor = true
		tutorial.visible = true
		await get_tree().create_timer(1).timeout
		animation_player.play("drag")

func _on_area_2d_input_event(_viewport, event, _shape_idx):
	if  event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			animation_player.play("fade")
			await animation_player.animation_finished
			queue_free()
