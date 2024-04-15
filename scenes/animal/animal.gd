extends RigidBody2D

@onready var label = $Label
@onready var arrow = $Arrow
@onready var stretch_sound = $StretchSound

const DRAG_LIMIT_MAX: Vector2 = Vector2(0, 60)
const DRAG_LIMIT_MIN: Vector2 = Vector2(-60, 0)

enum ANIMAL_STATE { READY, DRAG, RELEASE }

var _state: ANIMAL_STATE = ANIMAL_STATE.READY

var _start: Vector2 = Vector2.ZERO
var _drag_start: Vector2 = Vector2.ZERO
var _dragged_vector: Vector2 = Vector2.ZERO
var _last_dragged_vector: Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	arrow.hide()
	_start = position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	update(delta)
	label.text = "%s\n" % ANIMAL_STATE.keys()[_state]
	label.text += "%.1f,%.1f" % [_dragged_vector.x, _dragged_vector.y] 

func set_state(new_state: ANIMAL_STATE) -> void:
	_state = new_state
	if (_state == ANIMAL_STATE.RELEASE):
		freeze = false
		arrow.hide()
	elif (_state == ANIMAL_STATE.DRAG):
		_drag_start = get_global_mouse_position()
		arrow.show()

func detect_release() -> bool:
	if (_state == ANIMAL_STATE.DRAG):
		if (Input.is_action_just_released("drag") == true):
			set_state(ANIMAL_STATE.RELEASE)
			return true
	return false

func scale_arrow() -> void:
	arrow.rotation = (_start - position).angle()

func play_stretch_sound() -> void:
	if ((_last_dragged_vector - _dragged_vector).length() <= 0): 
		return
	
	if (stretch_sound.playing == false):
		stretch_sound.play()

func get_dragged_vector(gmp: Vector2) -> Vector2:
	return gmp - _drag_start

func drag_in_limits() -> void:
	_last_dragged_vector = _dragged_vector
	
	_dragged_vector.x = clampf(
		_dragged_vector.x,
		DRAG_LIMIT_MIN.x,
		DRAG_LIMIT_MAX.x
	)
	_dragged_vector.y = clampf(
		_dragged_vector.y,
		DRAG_LIMIT_MIN.y,
		DRAG_LIMIT_MAX.y
	)
	position = _start + _dragged_vector

func update_drag() -> void:
	if (detect_release() == true):
		return
	
	var gmp = get_global_mouse_position()
	_dragged_vector = get_dragged_vector(gmp)
	play_stretch_sound()
	drag_in_limits()
	scale_arrow()

func update(delta: float) -> void:
	match _state:
		ANIMAL_STATE.DRAG:
			update_drag()
		ANIMAL_STATE.RELEASE:
			pass

func die() -> void:
	SignalManager.on_animal_died.emit() # signal sender
	queue_free()

func _on_input_event(_viewport, event, _shape_idx):
	if (_state == ANIMAL_STATE.READY and event.is_action_pressed("drag")):
		set_state(ANIMAL_STATE.DRAG)
