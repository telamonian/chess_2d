class_name PieceManager extends Object

var pieces: Dictionary[Vector2i, Piece] = {}
var kings: Dictionary[int, Piece] = {}

func move_piece(grid_pos: Vector2i, new_grid_pos: Vector2i) -> void:
  var piece = pieces[grid_pos]

  if grid_pos != new_grid_pos:
    # piece has actually moved
    if new_grid_pos in pieces:
      # remove any pre-existing piece in new location
      remove_piece(new_grid_pos)

    pieces.erase(grid_pos)
    piece.move(new_grid_pos)
    #piece.move(new_grid_pos, game.board.grid_to_local(new_grid_pos))
    pieces[new_grid_pos] = piece

func remove_piece(grid_pos: Vector2i):
  var piece: Piece = pieces.get(grid_pos)

  pieces.erase(grid_pos)
  if piece.type == Enum.Ptype.KING:
    kings.erase(piece.player_id)
  piece.call_deferred("free")

func spawn_piece(player_id: int, pawn_dir: int, color: Enum.Pcolor, type: Enum.Ptype, grid_pos: Vector2i) -> Piece:
  var piece = Piece.new(player_id, pawn_dir, color, type, grid_pos)

  pieces[grid_pos] = piece

  return piece

func spawn_back(row: int, player_id: int, pawn_dir: int, color: Enum.Pcolor):
  # rooks
  for i in [0, 7]:
    spawn_piece(player_id, pawn_dir, color, Enum.Ptype.ROOK, Vector2i(i, row))

  # knights
  for i in [1, 6]:
    spawn_piece(player_id, pawn_dir, color, Enum.Ptype.KNIGHT, Vector2i(i, row))

  # bishops
  for i in [2, 5]:
    spawn_piece(player_id, pawn_dir, color, Enum.Ptype.BISHOP, Vector2i(i, row))

  # royals
  spawn_piece(player_id, pawn_dir, color, Enum.Ptype.QUEEN, Vector2i(3, row))
  var king = spawn_piece(player_id, pawn_dir, color, Enum.Ptype.KING, Vector2i(4, row))
  kings[player_id] = king

func spawn_front(row: int, player_id: int, pawn_dir: int, color: Enum.Pcolor):
  # pawns
  for i in range(8):
    spawn_piece(player_id, pawn_dir, color, Enum.Ptype.PAWN, Vector2i(i, row))

func spawn_pieces_for_player(player: Player):
  spawn_back(player.row_back, player.id, player.pawn_dir, player.color)
  spawn_front(player.row_front, player.id, player.pawn_dir, player.color)

func get_resources() -> Array[Piece.PieceResource]:
  var resources: Array[Piece.PieceResource] = []
  for piece in pieces.values():
    resources.append(piece.get_resource())
  return resources
