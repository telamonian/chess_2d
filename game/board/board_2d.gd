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

func is_inbounds(grid_pos: Vector2i) -> bool:
  return 0 <= grid_pos.x and grid_pos.x < FILES and 0 <= grid_pos.y and grid_pos.y < ROWS

func _ready() -> void:
  var piece_man = get_parent().get_node("Piece_manager")
  piece_man.piece_drag_started.connect(_on_piece_drag_started)
  piece_man.piece_drag_ended.connect(_on_piece_drag_ended)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass

func _on_piece_drag_started(piece: Piece2D):
  var pieces = get_parent().get_node("Piece_manager").pieces
  var player = get_parent().get_node("Player_manager").players[piece.player_id]
  var raw_moves = piece.get_moves(player)
  var moves: Array[Vector2i]

  # TODO: cleanup move validation code
  if piece.type == Enum.Ptype.PAWN:
    var root_move = raw_moves[0]
    if is_inbounds(root_move) and root_move not in pieces:
      moves.append(root_move)

      if not piece.is_moved:
        var double_move = Vector2i(root_move.x, root_move.y + player.pawn_dir)
        if is_inbounds(double_move) and double_move not in pieces:
          moves.append(double_move)

    for file_shift in [-1, 1]:
      var attack = Vector2i(root_move.x + file_shift, root_move.y)
      if is_inbounds(attack) and attack in pieces and pieces[attack].player_id != player.id:
        moves.append(attack)

  elif piece.type in [Enum.Ptype.BISHOP, Enum.Ptype.ROOK, Enum.Ptype.QUEEN]:
      for run in raw_moves:
        for move in run:
          if is_inbounds(move):
            if move not in pieces:
              moves.append(move)
            else:
              if pieces[move].player_id != player.id:
                moves.append(move)
              break
          else:
            break

  else:
    for move in raw_moves:
      if is_inbounds(move):
        if move not in pieces or pieces[move].player_id != player.id:
          moves.append(move)

  highlights.add_highlight(moves)

func _on_piece_drag_ended(piece: Piece2D):
  highlights.remove_highlight()
