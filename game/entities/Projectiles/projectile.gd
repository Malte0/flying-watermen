extends CharacterBody2D

class_name Projectile

@export var damage := 20
@export var speed := 1250.0

var player_speed := Vector2.ZERO
var direction := Vector2.ZERO
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var impact_detector := $ImpactDetector


func _ready():
	set_as_top_level(true)
	velocity = direction * speed
	velocity += player_speed

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta 
	
	move_and_slide()


func _on_impact_detector_body_entered(body):
	if body.owner.has_method("take_damage"):
		body.owner.take_damage(damage)
	queue_free()
