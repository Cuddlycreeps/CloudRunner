extends CharacterBody2D


# Constants
const MAX_JUMP_TIME = 0.3
const JUMP_VELOCITY = -400
const JUMP_EXTEND_VELOCITY = -200
const DOUBLE_JUMP_VELOCITY = -300
const DASH_SPEED = 1000
const SPEED = 300

# Variables
var jump_time = 0
var can_double_jump = false
var first_jump_press = false
var is_dashing : bool = false
var is_dashable : bool = true
var dash_timer = Timer.new()
var dash_cd_timer = Timer.new()


@onready var animations = $AnimatedSprite2D
@onready var jump_vocal_1 = $jump_vocal_1
@onready var jump_vocal_2 = $jump_vocal_2
@onready var jump_vocal_3 = $jump_vocal_3
@onready var jump_vocal_4 = $jump_vocal_4
@onready var jump_vocal_5 = $jump_vocal_5
@onready var jump = $jump
@onready var dash_projectile = $dash_projectile



# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	add_child(dash_timer)
	dash_timer.connect("timeout", _on_dash_timer_timeout)
	add_child(dash_cd_timer)
	dash_cd_timer.connect("timeout", _on_dash_cd_timer_timeout)
	dash_projectile.process_mode = Node.PROCESS_MODE_DISABLED

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_pressed("jump") and is_on_floor():
			first_jump_press = true
			velocity.y = JUMP_VELOCITY
			jump_sound()
	# Handle Jump Extend.
	if Input.is_action_just_released("jump"):
		first_jump_press = false
	if first_jump_press and jump_time < MAX_JUMP_TIME:
		jump_time += delta
		velocity.y = JUMP_EXTEND_VELOCITY
	# Handle Double Jump.
	if Input.is_action_just_pressed("jump") and !is_on_floor() and can_double_jump:
		velocity.y = DOUBLE_JUMP_VELOCITY
		jump_sound()
		can_double_jump = false
	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	# Handle Dash.
	if Input.is_action_pressed("dash") and !is_dashing and is_dashable:
		is_dashing = true
		is_dashable = false
		start_dash_timer()
		start_dash_cd_timer()
	if is_dashing:
		var dash_direction : int = 1
		if animations.flip_h:
			dash_direction = -1
		velocity.x = DASH_SPEED * dash_direction
	move_and_slide()
	player_animation()
	# Reset the double jump and the jump extend timer.
	if is_on_floor():
		can_double_jump = true
		jump_time = 0

func _on_dash_cd_timer_timeout():
	is_dashable = true

func start_dash_cd_timer():
	dash_cd_timer.start(3)

func _on_dash_timer_timeout():
	is_dashing = false
	dash_projectile.process_mode = Node.PROCESS_MODE_DISABLED
		
func start_dash_timer():
	dash_timer.start(0.2)
	dash_projectile.process_mode = Node.PROCESS_MODE_INHERIT

func jump_sound():
	velocity.y = JUMP_VELOCITY
	animations.play("jump_up")
	jump.play()
	var rand = randi() % 5
	match rand:
		0:
			jump_vocal_1.play()
		1:
			jump_vocal_2.play()
		2:
			jump_vocal_3.play()
		3:
			jump_vocal_4.play()
		4:
			jump_vocal_5.play()

func player_animation():
	if is_dashing:
		animations.play("dash")
	else:
		# Update the animation on the floor.
		if velocity.x != 0 and is_on_floor():
			animations.play("run")
		elif is_on_floor():
			animations.play("idle")
		# Update the jump animation.
		if !is_on_floor():		
			if velocity.y > 100:
				animations.play("jump_down")
			elif velocity.y < -100:
				animations.play("jump_up")
			else:
				animations.play("jump_top")
		# Flip the sprite.
		if velocity.x >= 0:
			animations.flip_h = false
			animations.offset.x = 18
		else:
			animations.flip_h = true
			animations.offset.x = -18
