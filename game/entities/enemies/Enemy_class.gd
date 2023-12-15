class_name Enemy extends DamageAbleEntity
# Use this to define shared behaviour of enemies

enum Movement_Direction { Left = -1, Right = 1 }

var movement_speed = 100

var weight: float = 1
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var jump_force: int = -500

var has_detected_player = false

func _init(_health: int, _weight: float, _jump_force: int, _movement_speed: int):
	weight = _weight
	jump_force = _jump_force
	movement_speed = _movement_speed
	super(_health, Element.Fire)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * weight * delta
	move_and_slide()

#region Movement

func jump():
	if is_on_floor():
		velocity.y = jump_force

func move(direction: Movement_Direction, delta):
	velocity.x = movement_speed * direction * delta;

#endregion

func on_player_detected(player: Player):
	print("FOUND PLAYER")
	has_detected_player = true

func forget_player():
	print("forget Player")
	has_detected_player = false
