extends Node2D

var spray_sprites = {
	0 : preload("res://Art Assets/Spray1.png"),
	1 : preload("res://Art Assets/Spray2.png")
}
@onready var sprite_2d = $Sprite2D

var angles_in_spray = 0
@onready var spraying_anim = $AnimationPlayer
@onready var angel_kill_area = $Area2D2/CollisionShape2D
@onready var spray_sfx = $AudioStreamPlayer2D

func _ready():
	$Sprite2D2.visible = false
	angel_kill_area.disabled = true

func _process(_delta):
	if angles_in_spray > 0:
		sprite_2d.texture = spray_sprites[1]
		if !spraying_anim.is_playing() || !spray_sfx.is_playing():
			$Sprite2D2.visible = true
			spray_sfx.play()
			spraying_anim.play("Spraying")
	else:
		sprite_2d.texture = spray_sprites[0]
		spray_sfx.stop()
		spraying_anim.stop()
		$Sprite2D2.visible = false

func _on_area_2d_2_area_entered(area):
	if area.is_in_group("angel"):
		angles_in_spray += 1

func _on_area_2d_2_area_exited(area):
	if area.is_in_group("angel"):
		angles_in_spray -= 1

func _on_area_2d_input_event(_viewport, event, _shape_idx):
	if  event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			angel_kill_area.disabled = false

func _input(event):
	if  event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
		if !event.pressed:
			angel_kill_area.disabled = true
