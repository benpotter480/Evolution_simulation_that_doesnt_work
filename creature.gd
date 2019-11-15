extends KinematicBody2D

var playing

# an array consiting of the possible animations of the creature
var animations = ["stationary_up","stationary_down","stationary_right","stationary_left",
	"move_up","move_down","move_right","move_left"]

# movement variables
var direction
var last_direction
var direction_changed

# used to go back to the last seen food after one is eaton or lost
var last_seen_food_pos

#health and energy are interchangable
#health defines how much health it has
#energy is used to move, using energy up means it cant move
#using health up means it dies

#creature defining variables
var SPEED
var SIGHT
var ORIGINAL_HEALTH
var METABOLIC_RATE # quantity of energy/health gained from food
var ORIGINAL_ENERGY
var HEALTH_ENERGY_EXCHANGE # dictates exchange of health to energy
var HEALTHINESS # rate of expense of energy
var MEMORY # dictates how long it can remember a food position
var BREEDING_RATE
var EXPECTED_OFFSPRING
var OFFSPRING_SURVIVABILITY
var MORTALITY
var MUTATION_RATE

# creature defining variable intial ranges
# using x as min y as max in vectors
# intialy have no value set in object insepctor for ease of modification
export var mm_SPEED = Vector2(0,0) 
export var mm_SIGHT = Vector2(0,0) 
export var mm_ORIGINAL_HEALTH = Vector2(0,0) 
export var mm_METABOLIC_RATE = Vector2(0,0) 
export var mm_ORIGINAL_ENERGY = Vector2(0,0) 
export var mm_HEALTH_ENERGY_EXCHANGE  = Vector2(0,0) 
export var mm_HEALTHINESS = Vector2(0,0) 
export var mm_MEMORY  = Vector2(0,0) 
export var mm_BREEDING_RATE = Vector2(0,0) 
export var mm_EXPECTED_OFFSPRING = Vector2(0,0) 
export var mm_OFFSPRING_SURVIVABILITY = Vector2(0,0) 
export var mm_MORTALITY = Vector2(0,0) 
export var mm_MUTATION_RATE = Vector2(0,0) 

# creature dependant variables
var current_health
var current_energy
var age

#used in collisions
var collision_size 


# Called when the node enters the scene tree for the first time.
func _ready():
	direction = Vector2(0,0)
	last_direction = Vector2(0,0)
	direction_changed = false
	playing = false
	
	collision_size = $creature_collision_body.shape.extents
	print(collision_size)


func _process(delta):
	# usimg direction for animation
	
	if direction == Vector2(0,0):
		$creature_animation.play(animations[1])
	if direction_changed:
		if abs(direction.x) > abs(direction.y):
			if direction.x > 0:
				$creature_animation.play(animations[6])
			else:
				$creature_animation.play(animations[7])
		else:
			if direction.y > 0:
				$creature_animation.play(animations[5])
			else:
				$creature_animation.play(animations[4])



## due to move and slide not working need to make my own collision detection for creatures
#func home_made_move_and_slide(creature_positions,delta):
#
#	# this is logically flawed we want to move in teh direction as far as we can within the range
#	var wanted_position = position + direction * SPEED * delta
#
#	var colliding = false
#	for creature_pos in creature_positions:
#		if !colliding:
#			#checking creature position isnt this position to ensure not checking ourself
#			if creature_pos == position:
#				pass
#			else:
#				var colliding_x = false
#				var colliding_y = false
#				# checking not colliding using size of collision body
#				var gap = collision_size
#
#				var creatureX = creature_pos.x
#				if creatureX - gap.x / 2 < wanted_position.x + gap.x / 2 and creatureX + gap.x / 2 > wanted_position.x - gap.x / 2:
#					colliding_x = true
#
#				var creatureY = creature_pos.y
#				if creatureY  - gap.y/2 < wanted_position.y + gap.x / 2 and creatureY + gap.y / 2 > wanted_position.y - gap.x / 2 :
#					colliding_y = true
#
#				# if both x and y colliding must be collidign
#				if colliding_x and colliding_y :
#					colliding = true
#
#	# if colldiing dont move
#	if colliding:
#		pass
#	else:
#		position = wanted_position
	

func move(food_positions, creature_positions, delta):
	if playing:
		direction = choose_direction(food_positions)
		move_and_slide(Vector2(0,0))

func play():
	playing = true

func pause():
	$creature_animation.play(animations[1])
	playing = false


func choose_direction(food_positions):
	var closest_food_pos = null
	var closest_food_distance = null
	# iterate through each food
	for food_pos in food_positions:
		# get distance betweeen the two positions
		var gap = food_pos - position
		var distance_food_me = sqrt(pow(gap.x,2) + pow(gap.y,2))
# insert test of within sight here
		# confiming that we are not comparing to null
		if closest_food_distance != null and closest_food_pos != null:
			# comparing distances
			if closest_food_distance > distance_food_me:
				# setting to closest food
				closest_food_distance = distance_food_me
				closest_food_pos = food_pos
		else:
			#if null need to set to first food to compare
			closest_food_distance = distance_food_me
			closest_food_pos = food_pos
		
	if closest_food_distance != null and closest_food_pos != null:
		var gap = closest_food_pos - position
		var go_direction = gap.normalized()
		return go_direction.normalized()
	else:
		# add ai go towards function call here
		return null


func initiate_creature_vals(window_size):
	SPEED = rand_range(mm_SPEED.x , mm_SPEED.y)
	SIGHT = rand_range(mm_SIGHT.x , mm_SIGHT.y)
	ORIGINAL_HEALTH = rand_range(mm_ORIGINAL_HEALTH.x , mm_ORIGINAL_HEALTH.y)
	METABOLIC_RATE = rand_range(mm_METABOLIC_RATE.x , mm_METABOLIC_RATE.y)
	ORIGINAL_ENERGY = rand_range(mm_ORIGINAL_ENERGY.x , mm_ORIGINAL_ENERGY.y)
	HEALTH_ENERGY_EXCHANGE = rand_range(mm_HEALTH_ENERGY_EXCHANGE.x , mm_HEALTH_ENERGY_EXCHANGE.y)
	HEALTHINESS = rand_range(mm_HEALTHINESS.x , mm_HEALTHINESS.y)
	MEMORY = rand_range(mm_MEMORY.x , mm_MEMORY.y)
	BREEDING_RATE = rand_range(mm_BREEDING_RATE.x , mm_BREEDING_RATE.y)
	EXPECTED_OFFSPRING = rand_range(mm_EXPECTED_OFFSPRING.x , mm_EXPECTED_OFFSPRING.y)
	OFFSPRING_SURVIVABILITY = rand_range(mm_OFFSPRING_SURVIVABILITY.x , mm_OFFSPRING_SURVIVABILITY.y)
	MORTALITY = rand_range(mm_MORTALITY.x , mm_MORTALITY.y)
	
	position = Vector2(rand_range(10,window_size.x-10),rand_range(10,window_size.y-10))
	
	current_health = ORIGINAL_HEALTH
	current_energy = ORIGINAL_ENERGY
	age = 0
	
	playing = true