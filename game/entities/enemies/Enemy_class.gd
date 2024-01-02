class_name Enemy extends CharacterBody2D

# Note: This script does not generalize well on enemies and is up to changes
@onready var health_component: HealthComponent = $HealthComponent
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

enum Movement_Direction { Left = -1, Right = 1, No = 0 }
var movement_direction: Movement_Direction = Movement_Direction.No
var movement_speed: int = 100

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	velocity.x = movement_speed * movement_direction;
	move_and_slide()

func jump(jump_force: float):
	if is_on_floor():
		velocity.y = jump_force

func move(direction: Movement_Direction):
	movement_direction = direction
