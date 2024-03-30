extends Interactable

@export var health_gained: int = 30

# Called when the node enters the scene tree for the first time.
func _ready():
	interact_hint = $E_key_dark

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_interacted(interactor):
	var health_component = interactor.get_node_or_null("HealthComponent")
	health_component.max_health += health_gained
	health_component.heal(health_gained)
	queue_free()
