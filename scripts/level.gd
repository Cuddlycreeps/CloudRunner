extends Node2D


func _on_win_area_body_entered(body):
	if body.is_in_group("Player"):
		#show_message("You win!")
		get_tree().change_scene_to_file("res://scenes/level.tscn")


func _on_death_area_body_entered(body):
	if body.is_in_group("Player"):
		#show_message("You died!")
		get_tree().change_scene_to_file("res://scenes/level.tscn")

# The player node.
@onready var player = $Player

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

func _process(delta):
	# Calculate the parallax offset based on the player's position.
	var offset = -player.position.x / 1000

	# Apply the parallax offset to each layer.
	layer1.position.x = offset * factor1
	layer2.position.x = offset * factor2
	layer3.position.x = offset * factor3
	layer4.position.x = offset * factor4
	layer5.position.x = offset * factor5

#Doesnt work
#func show_message(message: String):
#	var label = Label.new()
#	label.text = message
#	label.font = load("res://fonts/Cardinal.ttf")
#	label.font.size = 48
#	label.align = Label.PRESET_CENTER
#	add_child(label)
