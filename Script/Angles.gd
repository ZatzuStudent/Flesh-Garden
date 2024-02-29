extends CharacterBody2D

var speed =  200
@onready var sprite_2d = $Sprite2D
var direction
var angle
@onready var timer = $Timer
var target
var switch_direction_time = 1.2
@onready var health_bar = $ProgressBar


func _ready():
	health_bar.visible = false
	angel_anim.play("Fly")
	angle = randi_range(int(-2 * PI), int( 2 * PI))
	direction = Vector2(cos(angle), sin(angle))
	timer.wait_time = switch_direction_time

func _process(_delta):	
	var target_nodes = get_tree().get_nodes_in_group("planter")
	if target_nodes.size() >  0:
		target = target_nodes[0]  # Assuming the first node is the target
		direction = (target.global_position - global_position).normalized()
		timer.stop()
		if in_plant == false:
			velocity = direction * speed
		else:
			velocity.x = direction.x * 0
			if target.global_position.y <= 50:
				velocity.y = direction.y * 0
			else:
				velocity.y = direction.y * speed
	else:
		velocity = direction * speed
		timer.wait_time = switch_direction_time
	move_and_slide()
	if velocity.x > 0:
		sprite_2d.flip_h = false
	if velocity.x < 0:
		sprite_2d.flip_h = true
	
	if in_spray_area == true:
		health.value -= .05

	if health.value == 0:
		queue_free()

func _on_timer_timeout():
	angle = randi_range(int(-2 * PI), int( 2 * PI))
	direction = Vector2(cos(angle), sin(angle))
	
@onready var angel_anim = $AnimationPlayer
var in_plant = false
@onready var health = $ProgressBar
var in_spray_area = false

func _on_area_2d_area_entered(area):
	if area.is_in_group("planter"):
		angel_anim.play("Attack")
		in_plant = true
	if area.is_in_group("boarder_x"):
		direction.x = -direction.x
	if area.is_in_group("boarder_y"):
		direction.y = -direction.y
	if area.is_in_group("angel_killer"):
		in_spray_area = true
		health_bar.visible = true

func _on_area_2d_area_exited(area):
	if area.is_in_group("planter"):
		angel_anim.stop()
		angel_anim.play("Fly")
		in_plant = false
		timer.wait_time = switch_direction_time
		timer.autostart = true

	if area.is_in_group("angel_killer"):
		in_spray_area = false
		
