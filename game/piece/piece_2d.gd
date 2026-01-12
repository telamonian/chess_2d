extends Area2D
class_name Piece2D

@onready var sprite = $piece_sprite

var color: Enum.Pcolor
var type: Enum.Ptype
var grid_position: Vector2i
var old_scale: Vector2

var is_moved: bool = false
var is_dragged: bool = false

func setup(c: Enum.Pcolor, t: Enum.Ptype, grid_pos: Vector2i, pos: Vector2):
  color = c
  type = t
  grid_position = grid_pos

  old_scale = scale

  sprite.setup(color, type)
  position = pos


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  if is_dragged:
    position = get_global_mouse_position()


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
  if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
    if event.pressed:
      start_drag()
    elif is_dragged:
      end_drag()

func start_drag():
  is_dragged = true
  scale = Vector2(old_scale.x * 1.1, old_scale.y * 1.1)

func end_drag():
  scale = Vector2(old_scale)
  is_dragged = false
  get_parent().piece_drag_ended.emit(self)
