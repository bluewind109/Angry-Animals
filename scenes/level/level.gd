extends Node2D

const ANIMAL = preload("res://scenes/animal/animal.tscn")
const MAIN = preload("res://scenes/main/main.tscn")

@onready var animal_start = $AnimalStart

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalManager.on_animal_died.connect(on_animal_died) # signal listener
	add_animal()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if (Input.is_key_pressed(KEY_ESCAPE)):
		get_tree().change_scene_to_packed(MAIN)
	
func on_animal_died() -> void:
	add_animal()

func add_animal() -> void:
	var instance = ANIMAL.instantiate()
	call_deferred("add_child", instance)
	instance.position = animal_start.position
