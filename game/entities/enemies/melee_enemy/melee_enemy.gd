extends Enemy

@onready var wall_detection = $Flip/wall_detetion
@onready var healthBar = $EnemyHealthBar
@onready var nodes_to_flip: Node2D = $Flip

func _init():
	var max_health = 100  
	super(max_health)
	move(Movement_Direction.Right)

func _physics_process(delta):
	if is_on_wall():
		jump()
	if wall_detection.is_colliding():
		move(Movement_Direction.Left)
		flip()
	super(delta)

func flip():
	nodes_to_flip.scale.x *= -1

func _on_detection_range_body_entered(body):
	if body is Player:
		on_player_detected(body)

func _on_detection_range_body_exited():
	forget_player()

func _on_change_health(new_health):
	healthBar.change_health(new_health)
