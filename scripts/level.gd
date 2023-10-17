extends Node2D

# The player node.
@onready var player = $Player
# The tile map node.
@onready var tile_map = $TileMap

# The parallax layers.
@export var layer1 : ParallaxLayer
@export var layer2 : ParallaxLayer
@export var layer3 : ParallaxLayer
@export var layer4 : ParallaxLayer
@export var layer5 : ParallaxLayer

# The parallax factors for each layer.
@export var factor1 = 0.1
@export var factor2 = 0.2
@export var factor3 = 0.3
@export var factor4 = 0.4
@export var factor5 = 0.5

# player position
var player_position_as_tile

func _on_win_area_body_entered(body):
	if body.is_in_group("Player"):
		#show_message("You win!")
		reset_level()


func _on_death_area_body_entered(body):
	if body.is_in_group("Player"):
		#show_message("You died!")
		reset_level()

func reset_level():
	get_tree().change_scene_to_file("res://scenes/level.tscn")

# temporal for showing the bitmap
func _ready():
	create_island(1, Vector2i(100, 100))

func _process(delta):
	# Get the player's position as a tile. TODO implement map randomized map generation
	player_position_as_tile = tile_map.local_to_map(player.position)
	# and print it to the console.
	#print("Player position: " + str(player_position_as_tile.x) + ", " + str(player_position_as_tile.y))

	# Calculate the parallax offset based on the player's position.
	var offset = -player.position.x / 1000
	# Apply the parallax offset to each layer.
	layer1.position.x = offset * factor1 * delta
	layer2.position.x = offset * factor2 * delta
	layer3.position.x = offset * factor3 * delta
	layer4.position.x = offset * factor4 * delta
	layer5.position.x = offset * factor5 * delta

func create_island(x_position, size_vector):
	# create a bitmap
	var bitmap :BitMap = BitMap.new()
	var is_starting_level: bool 
	bitmap.create(size_vector)
	for y in range(size_vector.x):
		if y <=5 and randi() % 2 == 0:
			is_starting_level = true
		for x in range(size_vector.y):
			if y > 5 or is_starting_level:
				bitmap.set_bit(x, y, true)
	#beautify the bitmap by make it pointy to the bottom side
	for x in range(size_vector.x):
		var x_offset = 0
		for y in range(size_vector.y):
			x_offset += 1
			if x < x_offset or x > size_vector.x - x_offset:
				bitmap.set_bit(x, y, false)
	#draw the bitmap to the console
	for y in range(size_vector.x):
		var line = ""
		for x in range(size_vector.y):
			if bitmap.get_bit(x, y):
				line += "X"
			else:
				line += "_"
		print(line)

#Doesnt work yet
#func show_message(message: String):
#	var label = Label.new()
#	label.text = message
#	label.font = load("res://fonts/Cardinal.ttf")
#	label.font.size = 48
#	label.align = Label.PRESET_CENTER
#	add_child(label)
