class_name Piece extends Object

var player_id: int
var pawn_dir: int
var color: Enum.Pcolor
var type: Enum.Ptype
var grid_position: Vector2i

var is_moved: bool = false

var file:
  get():
    return grid_position.x
var row:
  get():
    return grid_position.y

func _init(player_id: int, pawn_dir: int, color: Enum.Pcolor, type: Enum.Ptype, grid_pos: Vector2i):
  setup(player_id, pawn_dir, color, type, grid_pos)

func move(grid_pos: Vector2i):
  grid_position = grid_pos
  is_moved = true

func setup(pid: int, pdir: int, c: Enum.Pcolor, t: Enum.Ptype, grid_pos: Vector2i):
  player_id = pid
  pawn_dir = pdir
  color = c
  type = t
  grid_position = grid_pos

func get_moves():
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
      return moves_pawn(file, row, pawn_dir)

func get_resource() -> PieceResource:
  return PieceResource.new(player_id, type, grid_position)

static func moves_pawn(file: int, row: int, pawn_dir: int) -> Array[Vector2i]:
  return [Vector2i(file, row + 1*pawn_dir)]

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

class PieceResource extends Resource:
  @export var player_id: int
  @export var type: Enum.Ptype
  @export var grid_position: Vector2i

  func _init(pid: int = 0, t: Enum.Ptype = Enum.Ptype.PAWN, grid_pos: Vector2i = Vector2i(-1, -1)):
    player_id = pid
    type = t
    grid_position = grid_pos
