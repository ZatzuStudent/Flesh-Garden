extends Node2D

@onready var sprite_2d = $Sprite2D
@onready var blooding_sfx = $AudioStreamPlayer2D
@onready var blooding_anim = $AnimationPlayer
var inside = 0
var sfx_playing = false

func _ready():
	sprite_2d.texture = preload("res://Art Assets/BloodCan_normal.png")
	
func _process(_delta):
	if inside >= 1 && sfx_playing == false:
		blooding_sfx.play()
		blooding_anim.play("blooding")
		sfx_playing = true
		if sfx_playing == true:
			pass
	elif inside == 0:
		blooding_sfx.stop()
		blooding_anim.stop()
		sfx_playing = false
		sprite_2d.texture = preload("res://Art Assets/BloodCan_normal.png")
	

func _on_area_2d_watering_area_entered(area):
	if area in get_tree().get_nodes_in_group("pots"):
		inside += 1

func _on_area_2d_watering_area_exited(area):
	if area in get_tree().get_nodes_in_group("pots"):
		inside -= 1
