class_name Piece2D extends Area2D

const PIECE_SCENE: PackedScene = preload("res://game/piece/piece_2d.tscn")

var engine_piece: Piece
var old_scale: Vector2
var is_dragged: bool = false

var file:
  get():
    return engine_piece.file
var row:
  get():
    return engine_piece.row

var player_id: int:
  get():
    return engine_piece.player_id
var pawn_dir: int:
  get():
    return engine_piece.pawn_dir
var color: Enum.Pcolor:
  get():
    return engine_piece.color
var type: Enum.Ptype:
  get():
    return engine_piece.type
var grid_position: Vector2i:
  get():
    return engine_piece.grid_position

var is_moved: bool = false

# static constructor/instantiator
# see: https://www.reddit.com/r/godot/comments/13pm5o5/comment/ktmmqp0
static func new_piece(eng_piece: Piece, pixel_pos: Vector2) -> Piece2D:
  #engine_piece = epiece
  # walrus operator assigns both value and type
  var new_piece_2d := PIECE_SCENE.instantiate()

  # at this point this node and any children exist, but any _ready and child._ready won't be called until this node is added to main tree (via eg add_child)
  new_piece_2d.setup(eng_piece, pixel_pos)

  return new_piece_2d

func move(pixel_pos: Vector2):
  position = pixel_pos

func setup(eng_piece: Piece, pixel_pos: Vector2):
  engine_piece = eng_piece
  old_scale = scale

  $Piece_Sprite.setup(engine_piece.color, engine_piece.type)
  position = pixel_pos

func start_drag():
  is_dragged = true
  $Piece_Sprite.set_highlight()
  scale = Vector2(old_scale.x * 1.25, old_scale.y * 1.25)

  get_parent().piece_drag_started.emit(self)

func end_drag():
  scale = Vector2(old_scale)
  $Piece_Sprite.unset_highlight()
  is_dragged = false

  get_parent().piece_drag_ended.emit(self)

func _ready() -> void:
  input_event.connect(_on_input_event)

func _process(delta: float) -> void:
  if is_dragged:
    position = get_global_mouse_position()

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
  if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
    if event.pressed:
      start_drag()
    elif is_dragged:
      end_drag()
