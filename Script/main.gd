extends Node

@onready var money = $Money
var customer_number
var customers = preload("res://Scene/customer_1.tscn")
var customer_last
var customer_now
@onready var MainTimer = $ClockTimer
@onready var day_colors = $Lights/DayColors

func _ready():
	var instance = customers.instantiate()
	instance.position = Vector2(-470,-216)
	call_deferred("add_child", instance)
	MainTimer.wait_time = GlobalScript.timePerday
	GlobalScript.time_of_day = 0

func _process(_delta):
	var sunrise = (MainTimer.wait_time-(MainTimer.wait_time-1))
	var sunset = (MainTimer.wait_time/2)
	var night = (MainTimer.wait_time/3)-5
	
	if MainTimer.time_left < sunrise && MainTimer.time_left > sunrise-.1 :
		day_colors.play("Sunrise")
		GlobalScript.time_of_day = 0
	elif MainTimer.time_left < night && MainTimer.time_left > night-.1:
		day_colors.play("night_time")
		GlobalScript.time_of_day = 1
	elif MainTimer.time_left < sunset && MainTimer.time_left > sunset-.1:
		day_colors.play("Sunset")
	await get_tree().create_timer(1).timeout
	
	if !has_node("Customer_1") && GlobalScript.time_of_day == 0:
		var instance = customers.instantiate()
		instance.position = Vector2(-470,-216)
		call_deferred("add_child", instance)
	$Day.text = str("Day: ", GlobalScript.day)
		
	money.text = str(GlobalScript.money)
	for i in range(4):
		get_node("Products/Label%d" % (i)).text = str(GlobalScript.storage[i])
		get_node("Products/Label4").text = str(GlobalScript.storage[9])
	GlobalScript.ClockTimer = MainTimer.time_left

func _on_get_area_2d_area_entered(area):
	if area in get_tree().get_nodes_in_group("seeds") || area in get_tree().get_nodes_in_group("pots"):
		GlobalScript.isEmpty = false

func _on_get_area_2d_area_exited(area):
	if area in get_tree().get_nodes_in_group("seeds") || area in get_tree().get_nodes_in_group("pots"):
		GlobalScript.isEmpty = true

func _on_clock_timer_timeout():
	GlobalScript.day += 1
<<<<<<< Updated upstream
=======
	
func load_game():
	if not FileAccess.file_exists("user://savegame.save"):
		return # Error! We don't have a save to load.

	# We need to revert the game state so we're not cloning objects
	# during loading. This will vary wildly depending on the needs of a
	# project, so take care with this step.
	# For our example, we will accomplish this by deleting saveable objects.
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for i in save_nodes:
		i.queue_free()

	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	var save_game = FileAccess.open("user://savegame.save", FileAccess.READ)
	while save_game.get_position() < save_game.get_length():
		var json_string = save_game.get_line()

		# Creates the helper class to interact with JSON
		var json = JSON.new()

		# Check if there is any error while parsing the JSON string, skip in case of failure
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue

		# Get the data from the JSON object
		var node_data = json.get_data()

		# Firstly, we need to create the object and add it to the tree and set its position.
		var new_object = load(node_data["filename"]).instantiate()
		get_node(node_data["parent"]).add_child(new_object)
		new_object.position = Vector2(node_data["pos_x"], node_data["pos_y"])

		# Now we set the remaining variables.
		for i in node_data.keys():
			if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
				continue
			new_object.set(i, node_data[i])


>>>>>>> Stashed changes
