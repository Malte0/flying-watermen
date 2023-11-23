class_name Projectile
extends CharacterBody2D


@export var SPEED := 900.0
var direction := Vector2.ZERO

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var hitbox := $HitBox
@onready var sprite := $Sprite
@onready var impact_detector := $ImpactDetector


func _ready():
	set_as_top_level(true)
	
	velocity = direction * SPEED

func _physics_process(delta):
	# Add the gravity.
	#impact_detector.body_entered.emit()
	if not is_on_floor():
		velocity.y += gravity * delta 


	move_and_slide()


func _on_impact_detector_body_entered(body):
	queue_free() # Replace with function body.
