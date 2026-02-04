extends Node2D

@warning_ignore("unused_signal")
signal piece_drag_started(piece: Piece2D)
signal piece_drag_ended(piece: Piece2D)

var pieces: Dictionary[Vector2i, Piece2D] = {}
var kings: Dictionary[int, Piece2D] = {}

@onready var game = get_parent()

func move_piece(grid_pos: Vector2i, new_grid_pos: Vector2i) -> void:
  var piece = pieces[grid_pos]

  if grid_pos != new_grid_pos:
    # piece has actually moved
    if new_grid_pos in pieces:
      # remove any pre-existing piece in new location
      remove_piece(new_grid_pos)

    pieces.erase(grid_pos)
    piece.move(game.board.grid_to_local(new_grid_pos))
    pieces[new_grid_pos] = piece

func remove_piece(grid_pos: Vector2i):
  var piece: Piece2D = pieces.get(grid_pos)

  pieces.erase(grid_pos)
  if piece.type == Enum.Ptype.KING:
    kings.erase(piece.player_id)
  remove_child(piece)
  piece.queue_free()

func spawn_piece(engine_piece: Piece) -> Piece2D:
  var grid_pos = engine_piece.grid_position
  var piece_2d = Piece2D.new_piece(engine_piece, game.board.grid_to_local(grid_pos))

  add_child(piece_2d)
  pieces[grid_pos] = piece_2d

  return piece_2d
