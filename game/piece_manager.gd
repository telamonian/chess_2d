extends Node2D

@warning_ignore("unused_signal")
signal piece_drag_started(piece: Piece2D)
signal piece_drag_ended(piece: Piece2D)

var pieces: Dictionary[Vector2i, Piece2D] = {}
var kings: Dictionary[int, Piece2D] = {}

func move_piece(grid_pos: Vector2i, new_grid_pos: Vector2i, detached: bool = false) -> void:
  var piece = pieces[grid_pos]

  if grid_pos != new_grid_pos:
    # piece has actually moved
    if new_grid_pos in pieces:
      # remove any pre-existing piece in new location
      remove_piece(new_grid_pos)

    pieces.erase(grid_pos)
    if not detached:
      piece.move(new_grid_pos, get_parent().board.grid_to_local(new_grid_pos))
    pieces[new_grid_pos] = piece

func remove_piece(grid_pos: Vector2i):
  var piece: Piece2D = pieces.get(grid_pos)

  pieces.erase(grid_pos)
  if piece.type == Enum.Ptype.KING:
    kings.erase(piece.player_id)
  remove_child(piece)
  piece.queue_free()

func spawn_piece(player_id: int, color: Enum.Pcolor, type: Enum.Ptype, grid_pos: Vector2i) -> Piece2D:
  # need to use PIECE_SCENE.instantiate() or equivalent here instead of eg Piece2D.new()
  # see: https://www.reddit.com/r/godot/comments/17o1mkz/comment/k7vhc0m
  var piece = Piece2D.new_piece(player_id, color, type, grid_pos, get_parent().board.grid_to_local(grid_pos))

  add_child(piece)
  pieces[grid_pos] = piece

  return piece

func spawn_back(row: int, player_id: int, color: Enum.Pcolor):
  # rooks
  for i in [0, 7]:
    spawn_piece(player_id, color, Enum.Ptype.ROOK, Vector2i(i, row))

  # knights
  for i in [1, 6]:
    spawn_piece(player_id, color, Enum.Ptype.KNIGHT, Vector2i(i, row))

  # bishops
  for i in [2, 5]:
    spawn_piece(player_id, color, Enum.Ptype.BISHOP, Vector2i(i, row))

  # royals
  spawn_piece(player_id, color, Enum.Ptype.QUEEN, Vector2i(3, row))
  var king = spawn_piece(player_id, color, Enum.Ptype.KING, Vector2i(4, row))
  kings[player_id] = king

func spawn_front(row: int, player_id: int, color: Enum.Pcolor):
  # pawns
  for i in range(8):
    spawn_piece(player_id, color, Enum.Ptype.PAWN, Vector2i(i, row))

func spawn_pieces_for_player(player: Player2D):
  spawn_back(player.row_back, player.id, player.color)
  spawn_front(player.row_front, player.id, player.color)
