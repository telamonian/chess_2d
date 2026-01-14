extends Node2D
class_name Board2D

var FILES: int
var ROWS: int

@onready var tmlayer = $TileMapLayer
@onready var highlights = $Highlights

func spawn_board(files: int, rows: int):
  FILES = files
  ROWS = rows

  tmlayer.spawn_board(FILES, ROWS)

func grid_to_local(grid_pos: Vector2i) -> Vector2:
  return tmlayer.grid_to_local(grid_pos)

func grid_to_global(grid_pos: Vector2i) -> Vector2:
  return tmlayer.grid_to_global(grid_pos)

func global_to_grid(global_pos: Vector2) -> Vector2i:
  return tmlayer.global_to_grid(global_pos)

func _ready() -> void:
  var game = get_parent()
  var piece_man = game.get_node("Piece_manager")

  piece_man.piece_drag_started.connect(_on_piece_drag_started)
  piece_man.piece_drag_ended.connect(_on_piece_drag_ended)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass

func _on_piece_drag_started(piece: Piece2D):
  var player = get_parent().get_node("Player_manager").players[piece.player_id]
  var raw_moves = piece.get_moves(player)
  # TODO: add real move validation code
  var moves: Array[Vector2i]
  if piece.type in [Enum.Ptype.BISHOP, Enum.Ptype.ROOK, Enum.Ptype.QUEEN]:
    for run in raw_moves:
      for move in run:
        moves.append(move)
  else:
    moves = raw_moves

  highlights.add_highlight(moves)

func _on_piece_drag_ended(piece: Piece2D):
  highlights.remove_highlight()
