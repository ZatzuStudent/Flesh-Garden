extends RigidBody2D

var isholding
var isCauldron
@onready var puffing = $Puffing
@onready var potion_sfx_pick = $AudioStreamPlayer2D
@onready var potion_sfx_drop = $AudioStreamPlayer2D2
@onready var puff_sfx = $AudioStreamPlayer2D3

func _ready():
	z_index = 20
	isholding = false
	infrog = false
	insellingarea = false
	puffing.play("Puff")
	puff_sfx.play()

func _process(_delta):
	if isholding == true:
		position = get_global_mouse_position()
	elif inPotionShelf == false:
		global_position = Vector2(-460,-184)

func _on_area_2d_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton && event.button_index == 1:
		if event.is_pressed():
			isholding = true
			rotation = 0
			potion_sfx_pick.play()
		else:
			if infrog == true || insellingarea == true:
				queue_free()
			isholding = false

var infrog
var insellingarea
var inPotionShelf = true
func _on_area_2d_area_entered(area):
	if area.is_in_group("potion_boarder"):
		inPotionShelf = true
	if area.is_in_group("frogs"):
		infrog = true
	if area.is_in_group("sellingArea"):
		insellingarea = true
	if area.is_in_group("potion_shelf") && isholding == false:
		potion_sfx_drop.play()

func _on_area_2d_area_exited(area):
	if area.is_in_group("potion_boarder"):
		inPotionShelf = false
	if area.is_in_group("frogs"):
		infrog = false
	if area.is_in_group("sellingArea"):
		insellingarea = false
