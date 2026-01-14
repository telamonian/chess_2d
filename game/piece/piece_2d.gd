class_name Piece2D
extends Area2D

const PIECE_SCENE: PackedScene = preload("res://game/piece/piece_2d.tscn")

var player_id: int
var color: Enum.Pcolor
var type: Enum.Ptype
var grid_position: Vector2i
var old_scale: Vector2

var is_moved: bool = false
var is_dragged: bool = false

# static constructor/instantiator
# see: https://www.reddit.com/r/godot/comments/13pm5o5/comment/ktmmqp0
static func new_piece(player_id: int, color: Enum.Pcolor, type: Enum.Ptype, grid_pos: Vector2i, pos: Vector2):
  # walrus operator assigns both value and type
  var new_piece := PIECE_SCENE.instantiate()

  # at this point this node and any children exist, but any _ready and child._ready won't be called until this node is added to main tree (via eg add_child)
  new_piece.setup(player_id, color, type, grid_pos, pos)

  return new_piece

func setup(pid: int, c: Enum.Pcolor, t: Enum.Ptype, grid_pos: Vector2i, pos: Vector2):
  player_id = pid
  color = c
  type = t
  grid_position = grid_pos
  old_scale = scale

  $piece_sprite.setup(color, type)
  position = pos


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  input_event.connect(_on_input_event)


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
  $piece_sprite.set_highlight()
  scale = Vector2(old_scale.x * 1.25, old_scale.y * 1.25)

  get_parent().piece_drag_started.emit(self)

func end_drag():
  scale = Vector2(old_scale)
  $piece_sprite.unset_highlight()
  is_dragged = false

  get_parent().piece_drag_ended.emit(self)
