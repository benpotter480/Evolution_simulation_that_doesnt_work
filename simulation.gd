extends Node2D

# width and height of the window it is displayed in
var WINDOW_WIDTH
var WINDOW_HEIGHT

# import the creature and food objects
export (PackedScene) var creature_obj
export (PackedScene) var food_obj

# main simulation lists
var creatures = []
var orig_creatures = []
var foods = []

# simulation booleans
var started
var playing


func _ready():
	# allows me to use random functions in this script
	randomize()
	WINDOW_WIDTH = get_viewport().size.x
	WINDOW_HEIGHT = get_viewport().size.y
	
	set_backround_position()
	
	# initating booleans
	started = false
	playing = false


func _physics_process(delta):
	if playing and started:
		var food_positions = []
		for food in foods:
			food_positions.append(food.position)
		
		var creature_positions = []
		for cret in creatures:
			creature_positions.append(cret.position)
			
		for i in range(len(creatures)):
			creatures[i].move(food_positions, creature_positions ,delta)


# sets up eveything to start simulation
func start_sim():
	#create creatures
	# get inital number of creatures
	for i in range(5):
		var new_creature = creature_obj.instance()
		add_child(new_creature)
		new_creature.initiate_creature_vals(Vector2(WINDOW_WIDTH,WINDOW_HEIGHT))
		creatures.append(new_creature)
		orig_creatures.append(new_creature)
	# create food
	for i in range(10 - 1):
		var new_food = food_obj.instance()
		add_child(new_food)
		foods.append(new_food)
		
	#set started to true
	started = true
	playing = true
	
func play_sim():
	if !started:
		start_sim()
	else:
		playing = true
		for creature in creatures:
			creature.play()

func pause_sim():
	playing = false
	for creature in creatures:
		creature.pause()
	
func stop_sim():
	pass
	
func change_ff_level():
	pass


# Sets the position of the cut out for the grass_background object
func set_backround_position():
	# the grass_backround sprite has native resolution 1920:1080
	# screen resolution set in ready
	var position_vector = Vector2(rand_range(0,1920-WINDOW_WIDTH),rand_range(0,1080 - WINDOW_HEIGHT))
	var scale_vector = Vector2(WINDOW_WIDTH,WINDOW_HEIGHT)
	# getting the node as it otherwise will not have been loaded at the call of this
	var grass_background = get_node("grass_background")
		# validating region mode turned on
	if !grass_background.region_enabled:
		grass_background.region_enabled = true
	# setting the region
	grass_background.region_rect  = Rect2(position_vector,scale_vector)
