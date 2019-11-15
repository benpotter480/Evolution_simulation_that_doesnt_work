extends Area2D

var WINDOW_WIDTH
var WINDOW_HEIGHT

func _ready():
	randomize()
	
	WINDOW_WIDTH = get_viewport().size.x
	WINDOW_HEIGHT = get_viewport().size.y
	
	# intially setting the position of food
	position = Vector2(rand_range(20,WINDOW_WIDTH-20),rand_range(20,WINDOW_HEIGHT-20))