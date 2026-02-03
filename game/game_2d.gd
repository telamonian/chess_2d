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
  match piece.type:
    Enum.Ptype.KING:
      valid_moves.append_array(get_valid_castling_moves(piece))
    Enum.Ptype.PAWN:
      pass

  if new_grid_pos in valid_moves:
    # the move is valid, finalize the move
    piece_man.move_piece(grid_pos, new_grid_pos)
    return true
  else:
    # the move is invalid, snap the piece back to its original position
    piece.position = board.grid_to_local(grid_pos)
    return false

func is_threatened(piece: Piece2D) -> bool:
  var pieces = piece_man.pieces
  var player = player_man.players[piece.player_id]

  # check for pawn threats
  for move in [
    Vector2i(piece.file - 1, piece.row + player.pawn_dir),
    Vector2i(piece.file + 1, piece.row + player.pawn_dir)
  ]:
    if board.is_inbound(move):
      if move in pieces:
        var potential_threat = pieces[move]
        if potential_threat.color != player.color and potential_threat.type == Enum.Ptype.PAWN:
          return true

  # check for knight and king threats
  for ptype in [Enum.Ptype.KNIGHT, Enum.Ptype.KING]:
    for move in piece.moves_knight() if ptype == Enum.Ptype.KNIGHT else piece.moves_king():
      if board.is_inbounds(move):
        if move in pieces:
          var potential_threat = pieces[move]
          if potential_threat.color != player.color and potential_threat.type == ptype:
            return true

  # check for bishop, rook, and queen threats
  for run in piece.moves_bishop():
    for move in run:
      if board.is_inbounds(move):
        if move in pieces:
          var potential_threat = pieces[move]
          if potential_threat.color != player.color and potential_threat.type in [Enum.Ptype.BISHOP, Enum.Ptype.QUEEN]:
            return true
          else:
            break
        else:
          break

  for run in piece.moves_rook():
    for move in run:
      if board.is_inbounds(move):
        if move in pieces:
          var potential_threat = pieces[move]
          if potential_threat.color == player.color and potential_threat.type in [Enum.Ptype.ROOK, Enum.Ptype.QUEEN]:
            return true
          else:
            break
        else:
          break

  # if no threats are found, return false
  return false

func get_valid_moves(piece: Piece2D) -> Array[Vector2i]:
  var pieces = piece_man.pieces
  var player = player_man.players[piece.player_id]
  var raw_moves = piece.get_moves(player)
  var moves: Array[Vector2i]

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

func get_valid_castling_moves(piece: Piece2D) -> Array[Vector2i]:
  var valid_castling_moves: Array[Vector2i] = []
  if not piece.is_moved:
    # the king has not moved
    for rgp in player_man.players[piece.color].rook_grid_positions:
      if rgp in piece_man.pieces:
        var maybe_rook = piece_man.pieces[rgp]
        if maybe_rook.type == Enum.Ptype.ROOK and not maybe_rook.is_moved:
          # one of the same colored rooks has not moved
          #for file in range()
          var king_shift = -2 if piece.file - maybe_rook.file > 0 else 2
          # move the king 2 towards the unmoved rook
          valid_castling_moves.append(Vector2i(piece.file + king_shift, piece.row))
  return valid_castling_moves

func _on_piece_drag_started(piece: Piece2D):
  var valid_moves = get_valid_moves(piece)
  match piece.type:
    Enum.Ptype.KING:
      valid_moves.append_array(get_valid_castling_moves(piece))
  board.highlights.set_highlight(valid_moves)

func _on_piece_drag_ended(piece: Piece2D):
  board.highlights.remove_highlight()
  var new_grid_pos = board.global_to_grid(piece.position)
  move_piece(piece.grid_position, new_grid_pos)
