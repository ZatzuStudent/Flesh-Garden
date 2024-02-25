extends CharacterBody2D

var isholding
var isCauldron

func _ready():
	inCauldron = false
	isholding = true

func _process(_delta):
	if isholding == true:
		var direction : Vector2 = (get_global_mouse_position() - global_position)
		if direction.length() < 50:
			direction = direction.normalized()*1
		elif direction.length() >= 50:
			direction = direction.normalized()*5000
		velocity = direction
	else:
		if isCauldron == true:
			position.y += 10
		else:
			queue_free()
	move_and_slide()

var inCauldron
func _on_area_2d_area_entered(area):
	if area.is_in_group("CauldronPot"):
		await get_tree().create_timer(.2).timeout
		if GlobalScript.is_cauldron_area == false:
			queue_free()
	if area.is_in_group("fallArea"):
		isCauldron = true

func _on_area_2d_area_exited(area):
	if area.is_in_group("fallArea"):
		isCauldron = false
		
func _on_area_2d_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton && event.button_index == 1:
		if event.is_pressed():
			isholding = true
		else:
			isholding = false

func _input( event ):
	if event is InputEventMouseButton:
		if event.button_index == 1 and !event.is_pressed():
			isholding = false



