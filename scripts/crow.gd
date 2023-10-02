extends Area2D

@export var path_follow : PathFollow2D
@export var speed : float = 0.0025
@onready var animated_sprite_2d = $AnimatedSprite2D


var is_alive : bool = true
var death_animation_timer = Timer.new()

var past_x = null

func _ready():
	add_child(death_animation_timer)
	death_animation_timer.connect("timeout", _on_death_animation_timer_timeout)

func _physics_process(delta):
	if past_x != null:
		if global_position.x <= past_x:
			animated_sprite_2d.flip_h = true
		else:
			animated_sprite_2d.flip_h = false
		
	past_x = global_position.x
		
	if path_follow != null:
		path_follow.progress_ratio += speed * delta
		animated_sprite_2d.play("walk")

func _on_death_animation_timer_timeout():
	queue_free()

func start_death_animation_timer():
	death_animation_timer.start(0.5)

func _on_body_entered(body):
	if body.is_in_group("Player") and is_alive:
		get_tree().change_scene_to_file("res://scenes/level.tscn")

func _on_dash_projectile_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	if is_alive:
		start_death_animation_timer()
		is_alive = false
		path_follow = null
		animated_sprite_2d.play("death")
