extends CharacterBody2D

@export var speed = 300.0
@export var jump_velocity = -400.0

@onready var player = $AnimatedSprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction = 0.0

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if (Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("w")) and is_on_floor():
		velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_axis("a", "d")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	if position.x < -200:
		position.x = 600
	update_animation()
	move_and_slide()

var animation_locked = false
func update_animation():
	if not animation_locked:
		if player.flip_h and direction > 0:
			player.flip_h = false
			player.move_local_x(10)
		elif not player.flip_h and direction < 0:
			player.flip_h = true
			player.move_local_x(-10)

		if velocity.y < 0:
			player.play("jump")
		elif velocity.y > 0:
			if player.animation == "jump":
				player.play("jumpfallinbetween")
			else:
				player.play("fall")
		elif velocity.x != 0:
			player.play("run")
		else:
			player.play("idle")
