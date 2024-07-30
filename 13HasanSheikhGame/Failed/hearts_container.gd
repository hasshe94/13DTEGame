extends HBoxContainer
@onready var heartGuiClass = preload("res://Scenes/heart_gui.tscn")



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func setMaxHearts(max: int):
	for i in range(max):
		var heart = heartGuiClass.instantiate()
		add_child(heart)
