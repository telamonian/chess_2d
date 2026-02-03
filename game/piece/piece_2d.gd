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

var file:
  get():
    return grid_position.x
var row:
  get():
    return grid_position.y

# static constructor/instantiator
# see: https://www.reddit.com/r/godot/comments/13pm5o5/comment/ktmmqp0
static func new_piece(player_id: int, color: Enum.Pcolor, type: Enum.Ptype, grid_pos: Vector2i, pos: Vector2):
  # walrus operator assigns both value and type
  var new_piece := PIECE_SCENE.instantiate()

  # at this point this node and any children exist, but any _ready and child._ready won't be called until this node is added to main tree (via eg add_child)
  new_piece.setup(player_id, color, type, grid_pos, pos)

  return new_piece

func move(grid_pos: Vector2i, pos: Vector2):
  grid_position = grid_pos
  position = pos
  is_moved = true

func setup(pid: int, c: Enum.Pcolor, t: Enum.Ptype, grid_pos: Vector2i, pos: Vector2):
  player_id = pid
  color = c
  type = t
  grid_position = grid_pos
  old_scale = scale

  $Piece_Sprite.setup(color, type)
  position = pos

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

static func moves_pawn(file: int, row: int, player: Player2D) -> Array[Vector2i]:
  return [Vector2i(file, row + 1*player.pawn_dir)]

static func moves_knight(file: int, row: int) -> Array[Vector2i]:
  var moves: Array[Vector2i] = []

  for i in [-2, 2]:
    for j in [-1, 1]:
      moves.append(Vector2i(file + i, row + j))
      moves.append(Vector2i(file + j, row + i))

  return moves

static func moves_king(file: int, row: int) -> Array[Vector2i]:
  var moves: Array[Vector2i] = []

  for i in [-1, 0, 1]:
    for j in [-1, 0, 1]:
      if i != 0 or j != 0:
        moves.append(Vector2i(file + i, row + j))

  return moves

static func moves_rook(file: int, row: int) -> Array[Array]:
  var moves: Array[Array] = []

  for i in [-1, 1]:
    var moves_file: Array[Vector2i] = []
    var moves_row: Array[Vector2i] = []

    for j in range(1, 8):
      moves_file.append(Vector2i(file, row + i*j))
      moves_row.append(Vector2i(file + i*j, row))

    moves.append(moves_file)
    moves.append(moves_row)

  return moves

static func moves_bishop(file: int, row: int) -> Array[Array]:
  var moves: Array[Array] = []

  for i in [-1, 1]:
    var moves_positive_diagonal: Array[Vector2i] = []
    var moves_negative_diagonal: Array[Vector2i] = []

    for j in range(1, 8):
      moves_positive_diagonal.append(Vector2i(file + i*j, row + i*j))
      moves_negative_diagonal.append(Vector2i(file - i*j, row + i*j))

    moves.append(moves_positive_diagonal)
    moves.append(moves_negative_diagonal)

  return moves

static func moves_queen(file: int, row: int) -> Array[Array]:
  var moves = moves_rook(file, row)
  moves.append_array(moves_bishop(file, row))
  return moves

func get_moves(player: Player2D):
  match type:
    Enum.Ptype.KING:
      return moves_king(file, row)
    Enum.Ptype.QUEEN:
      return moves_queen(file, row)
    Enum.Ptype.BISHOP:
      return moves_bishop(file, row)
    Enum.Ptype.KNIGHT:
      return moves_knight(file, row)
    Enum.Ptype.ROOK:
      return moves_rook(file, row)
    Enum.Ptype.PAWN:
      return moves_pawn(file, row, player)

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
