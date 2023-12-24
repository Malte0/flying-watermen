class_name Enemy extends CharacterBody2D

@export var carried_item: PackedScene
@export var health_component: HealthComponent
@export var weight: float = 1
@export var jump_force: int = -500
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

enum Movement_Direction { Left = -1, Right = 1, No = 0 }
var movement_direction: Movement_Direction = Movement_Direction.No
var movement_speed: int = 100

func _ready():
	health_component.death.connect(drop_item)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * weight * delta
	velocity.x = movement_speed * movement_direction;
	move_and_slide()

func jump(force: float):
	if is_on_floor():
		velocity.y = jump_force * force

func move(direction: Movement_Direction):
	movement_direction = direction

func drop_item():
	if carried_item:
		var item_instance = carried_item.instantiate()
		item_instance.position = position
		get_parent().add_child(item_instance)
