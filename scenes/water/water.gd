extends Area2D

@onready var splash = $Splash

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_body_entered(body):
	if (body.has_method("die") == true):
		body.die()
		splash.play()
