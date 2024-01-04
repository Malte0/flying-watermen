extends Sprite2D

#@onready var health_component: HealthComponent = $HealthComponent
@onready var player: Player = get_tree().get_first_node_in_group("player")

const damage: int = 10
var body_inside : bool = false
var take_damage: bool = false

func _ready():
	$Area2D/Timer.start()
	
func _process(delta):
	if body_inside && take_damage:
		player.health_component.take_damage(damage,Element.Type.Neutral)
		take_damage = false
		

	
	
func _on_area_2d_body_entered(body):
	if body == player:
		body_inside = true
		print("player inside")
		


func _on_area_2d_body_exited(body):
	if body == player:
		body_inside = false
		print("player outside")
	

func _on_timer_timeout():
	take_damage = true
	$Area2D/Timer.start()
	print("timer")
	
