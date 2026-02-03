extends Node2D

@onready var player_man = $Player_Manager
@onready var piece_man = $Piece_Manager
@onready var board = $Board_2d

func spawn_game():
  board.spawn_board(8, 8)

  player_man.spawn_player(0, Enum.Pcolor.WHITE)
  player_man.spawn_player(1, Enum.Pcolor.BLACK)

  for player in player_man.players.values():
    piece_man.spawn_pieces_for_player(player)

func _ready() -> void:
  spawn_game()
  piece_man.piece_drag_started.connect(_on_piece_drag_started)
  piece_man.piece_drag_ended.connect(_on_piece_drag_ended)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass

func move_piece(grid_pos: Vector2i, new_grid_pos: Vector2i) -> bool:
  var piece = piece_man.pieces[grid_pos]
  var valid_moves = get_valid_moves(piece)
  if new_grid_pos in valid_moves:
    # the move is valid, finalize the move
    piece_man.move_piece(grid_pos, new_grid_pos)
    return true
  else:
    # the move is invalid, snap the piece back to its original position
    piece.position = board.grid_to_local(grid_pos)
    return false

func get_valid_moves(piece: Piece2D) -> Array[Vector2i]:
  var pieces = piece_man.pieces
  var player = player_man.players[piece.player_id]
  var raw_moves = piece.get_moves(player)
  var moves: Array[Vector2i]

  # TODO: cleanup move validation code
  if piece.type == Enum.Ptype.PAWN:
    var root_move = raw_moves[0]
    if board.is_inbounds(root_move) and root_move not in pieces:
      moves.append(root_move)

      if not piece.is_moved:
        var double_move = Vector2i(root_move.x, root_move.y + player.pawn_dir)
        if board.is_inbounds(double_move) and double_move not in pieces:
          moves.append(double_move)

    for file_shift in [-1, 1]:
      var attack = Vector2i(root_move.x + file_shift, root_move.y)
      if board.is_inbounds(attack) and attack in pieces and pieces[attack].player_id != player.id:
        moves.append(attack)

  elif piece.type in [Enum.Ptype.BISHOP, Enum.Ptype.ROOK, Enum.Ptype.QUEEN]:
      for run in raw_moves:
        for move in run:
          if board.is_inbounds(move):
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
      if board.is_inbounds(move):
        if move not in pieces or pieces[move].player_id != player.id:
          moves.append(move)

  return moves

func _on_piece_drag_started(piece: Piece2D):
  var valid_moves = get_valid_moves(piece)
  board.highlights.set_highlight(valid_moves)

func _on_piece_drag_ended(piece: Piece2D):
  board.highlights.remove_highlight()
  var new_grid_pos = board.global_to_grid(piece.position)
  move_piece(piece.grid_position, new_grid_pos)
