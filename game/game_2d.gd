extends Node2D

@onready var player_man = $Player_2d_Manager
@onready var piece_man = $Piece_2d_Manager
@onready var board = $Board_2d

var main_engine: ChessEngine = ChessEngine.new()

func spawn_game(files: int = 8, rows: int = 8) -> void:
  # spawn the game logic
  main_engine.spawn_game(files, rows)

  # spawn the game gui
  board.spawn_board(files, rows)
  for engine_player in main_engine.player_man.players.values():
    player_man.spawn_player(engine_player)
  for engine_piece in main_engine.piece_man.pieces.values():
    piece_man.spawn_piece(engine_piece)

func _ready() -> void:
  spawn_game()

  main_engine.rook_castled.connect(_on_rook_castled)

  piece_man.piece_drag_started.connect(_on_piece_drag_started)
  piece_man.piece_drag_ended.connect(_on_piece_drag_ended)

func move_piece(grid_pos: Vector2i, new_grid_pos: Vector2i) -> bool:
  var piece_2d: Piece2D = piece_man.pieces[grid_pos]
  if main_engine.move_piece(grid_pos, new_grid_pos):
    piece_man.move_piece(grid_pos, new_grid_pos)
    return true
  else:
    piece_2d.position = board.grid_to_local(grid_pos)
    return false

func get_valid_moves(piece_2d: Piece2D):
  return main_engine.get_valid_moves(piece_2d.engine_piece)

func get_valid_castling_moves(piece_2d: Piece2D):
  return main_engine.get_valid_castling_moves(piece_2d.engine_piece)

func _on_piece_drag_started(piece_2d: Piece2D):
  var valid_moves = get_valid_moves(piece_2d)
  match piece_2d.engine_piece.type:
    Enum.Ptype.KING:
      valid_moves.append_array(get_valid_castling_moves(piece_2d))
  board.highlights.set_highlight(valid_moves)

func _on_piece_drag_ended(piece_2d: Piece2D):
  board.highlights.remove_highlight()
  var new_grid_pos = board.global_to_grid(piece_2d.position)
  move_piece(piece_2d.engine_piece.grid_position, new_grid_pos)

func _on_rook_castled(grid_pos: Vector2i, new_grid_pos: Vector2i):
  piece_man.move_piece(grid_pos, new_grid_pos)
