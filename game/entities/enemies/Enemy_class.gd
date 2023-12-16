class_name Enemy extends DamageAbleEntity
# Use this to define shared behaviour of enemies

enum Movement_Direction { Left = -1, Right = 1, No = 0 }
var movement_direction: Movement_Direction = Movement_Direction.No

var movement_speed: int = 100

var weight: float = 1
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var jump_force: int = -500

var has_detected_player: bool = false

func _init(_max_health):
	super(Element.Fire, _max_health)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * weight * delta
	velocity.x = movement_speed * movement_direction;
	move_and_slide()

#region Movement

func jump():
	if is_on_floor():
		velocity.y = jump_force

func move(direction: Movement_Direction):
	movement_direction = direction

#endregion

func on_player_detected(player: Player):
	print("FOUND PLAYER")
	has_detected_player = true

func forget_player():
	print("forget Player")
	has_detected_player = false
