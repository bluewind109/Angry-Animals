extends Node2D

const ANIMAL = preload("res://scenes/animal/animal.tscn")

@onready var animal_start = $AnimalStart

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalManager.on_animal_died.connect(on_animal_died) # signal listener
	add_animal()
	
func on_animal_died() -> void:
	add_animal()

func add_animal() -> void:
	var instance = ANIMAL.instantiate()
	call_deferred("add_child", instance)
	instance.position = animal_start.position
