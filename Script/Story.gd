extends Node2D

var customer_stories = {
	0 : {first="one",second="two"},
	1 : {first="one",second="two"},
	2 : {first="one",second="two"},
	3 : {first="one",second="two"},
	4 : {first="one",second="two"}
}

func _process(_delta):
	if GlobalScript.day == 0:
		pass
