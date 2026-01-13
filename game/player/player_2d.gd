extends Node2D
class_name Player2D

var id: int
var color: Enum.Pcolor
var is_in_check: bool = false

var row_back: int
var row_front: int
var row_promote: int
var pawn_dir: int

#var pieces: Dictionary[Vector2i, Piece2D] = {}


func setup(new_id: int, new_color: Enum.Pcolor):
  id = new_id
  color = new_color

  if color == Enum.Pcolor.WHITE:
    row_back = 0
    row_front = 1
    row_promote = 7
    pawn_dir = 1
  elif color == Enum.Pcolor.BLACK:
    row_back = 7
    row_front = 6
    row_promote = 0
    pawn_dir = -1

func moves_pawn(grid_pos: Vector2i) -> Array[Vector2i]:
  var file = grid_pos.x
  var row = grid_pos.y
  return [
    Vector2i(file, row + 1*pawn_dir),
    Vector2i(file + 1, row + 1*pawn_dir),
    Vector2i(file - 1, row + 1*pawn_dir),
    Vector2i(file, row + 2*pawn_dir)
  ]

func moves_knight(grid_pos: Vector2i) -> Array[Vector2i]:
  var file = grid_pos.x
  var row = grid_pos.y
  var moves: Array[Vector2i] = []

  for i in [-2, 2]:
    for j in [-1, 1]:
      moves.append(Vector2i(file + i, row + j))
      moves.append(Vector2i(file + j, row + i))

  return moves

func moves_king(grid_pos: Vector2i) -> Array[Vector2i]:
  var file = grid_pos.x
  var row = grid_pos.y
  var moves: Array[Vector2i] = []

  for i in [-1, 0, 1]:
    for j in [-1, 0, 1]:
      if i != 0 or j != 0:
        moves.append(Vector2i(file + i, row + j))

  return moves

func moves_rook(grid_pos: Vector2i) -> Array[Array]:
  var file = grid_pos.x
  var row = grid_pos.y
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

func moves_bishop(grid_pos: Vector2i) -> Array[Array]:
  var file = grid_pos.x
  var row = grid_pos.y
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

func moves_queen(grid_pos: Vector2i) -> Array[Array]:
  var moves = moves_rook(grid_pos)
  moves.append_array(moves_bishop(grid_pos))
  return moves

func get_moves(type: Enum.Ptype, grid_pos: Vector2i):
  match type:
    Enum.Ptype.KING:
      return moves_king(grid_pos)
    Enum.Ptype.QUEEN:
      return moves_queen(grid_pos)
    Enum.Ptype.BISHOP:
      return moves_bishop(grid_pos)
    Enum.Ptype.KNIGHT:
      return moves_knight(grid_pos)
    Enum.Ptype.ROOK:
      return moves_rook(grid_pos)
    Enum.Ptype.PAWN:
      return moves_pawn(grid_pos)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass
