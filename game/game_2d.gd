extends Node2D

@onready var player_man = $Player_Manager
@onready var piece_man = $Piece_Manager
@onready var board = $Board_2d

#var player_man = get_node("Player_Manager")
#var piece_man = get_node("Piece_Manager")
#var board = get_node("Board_2d")

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

func move_piece(grid_pos: Vector2i, new_grid_pos: Vector2i) -> bool:
  var piece = piece_man.pieces[grid_pos]
  var player = player_man.players[piece.player_id]
  var valid_moves = get_valid_moves(piece)

  # special handling for castling, en passant, etc
  match piece.type:
    Enum.Ptype.KING:
      var valid_castling_moves = get_valid_castling_moves(piece)
      if new_grid_pos in valid_castling_moves:
        var shift = -1 if grid_pos.x - new_grid_pos.x > 0 else 1
        var rook_grid_pos = player.rook_grid_positions[0 if shift == -1 else 1]
        # position the rook next to the castled king, on the side closest to the king's original square
        var new_rook_grid_pos = Vector2i(grid_pos.x + shift, rook_grid_pos.y)

        piece_man.move_piece(grid_pos, new_grid_pos)
        piece_man.move_piece(rook_grid_pos, new_rook_grid_pos)
        return true
    Enum.Ptype.PAWN:
      #TODO: add en passant handling
      pass

  if new_grid_pos in valid_moves:
    # the move is valid, finalize the move
    piece_man.move_piece(grid_pos, new_grid_pos)
    return true
  else:
    # the move is invalid, snap the piece back to its original position
    piece.position = board.grid_to_local(grid_pos)
    return false

func is_threatened(file: int, row: int, player_id: int) -> bool:
  var pieces = get_node("Piece_Manager").pieces
  var player = get_node("Player_Manager").players[player_id]
  var board = get_node("Board_2d")

  # check for pawn threats
  for move in [
    Vector2i(file - 1, row + player.pawn_dir),
    Vector2i(file + 1, row + player.pawn_dir)
  ]:
    if board.is_inbounds(move):
      if move in pieces:
        var potential_threat = pieces[move]
        if potential_threat.color != player.color and potential_threat.type == Enum.Ptype.PAWN:
          return true

  # check for knight and king threats
  for ptype in [Enum.Ptype.KNIGHT, Enum.Ptype.KING]:
    for move in Piece2D.moves_knight(file, row) if ptype == Enum.Ptype.KNIGHT else Piece2D.moves_king(file, row):
      if board.is_inbounds(move):
        if move in pieces:
          var potential_threat = pieces[move]
          if potential_threat.color != player.color and potential_threat.type == ptype:
            return true

  # check for bishop, rook, and queen threats
  for ptype in [Enum.Ptype.BISHOP, Enum.Ptype.ROOK]:
    for run in Piece2D.moves_bishop(file, row) if ptype == Enum.Ptype.BISHOP else Piece2D.moves_rook(file, row):
      for move in run:
        if board.is_inbounds(move):
          if move in pieces:
            var potential_threat = pieces[move]
            if potential_threat.color != player.color and potential_threat.type in [ptype, Enum.Ptype.QUEEN]:
              return true
            else:
              break
        else:
          break

  # if no threats are found, return false
  return false

func is_checked(player_id: int) -> bool:
  var king = get_node("Piece_Manager").kings[player_id]
  return is_threatened(king.file, king.row, player_id)

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

  return filter_checked(piece, moves)

#TODO: figure out a way to check checked without moving around the actual game pieces
#TODO: add handling for getting out of check
func filter_checked(piece: Piece2D, moves: Array[Vector2i]) -> Array[Vector2i]:
  var player_id = piece.player_id
  var filtered: Array[Vector2i] = []
  var grid_pos = piece.grid_position
  #var original_is_moved = piece.is_moved
  #var original_grid_pos = piece.grid_position
  #var current_grid_pos = original_grid_pos
  #var buffer_grid_pos = Vector2i(-1, -1)

  for move in moves:
    var dupe = duplicate(23)
    var dupe_piece_man = dupe.get_node("Piece_Manager")
    var dupe_player_man = dupe.get_node("Player_Manager")

    dupe_piece_man.pieces = piece_man.pieces.duplicate_deep()
    for pid in piece_man.kings.keys():
      var king = piece_man.kings[pid]
      dupe_piece_man.kings[pid] = dupe_piece_man.pieces[king.grid_position]
    dupe_player_man.players = player_man.players.duplicate_deep()

    #dupe.piece_man.move_piece(grid_pos, move)
    dupe_piece_man.move_piece(grid_pos, move, true)
    #current_grid_pos = move
    if not dupe.is_checked(player_id):
      filtered.append(move)

    dupe.queue_free()

  #piece_man.move_piece(original_grid_pos, buffer_grid_pos)
  #if not is_checked(player_id):
    #filtered = moves
#
  #piece_man.move_piece(buffer_grid_pos, original_grid_pos)
  #piece.is_moved = original_is_moved
  return filtered

func get_valid_castling_moves(piece: Piece2D) -> Array[Vector2i]:
  var pieces = piece_man.pieces

  var valid_castling_moves: Array[Vector2i] = []
  if not piece.is_moved and not is_threatened(piece.file, piece.row, piece.player_id):
    # the king has not moved and is not in check
    for rgp in player_man.players[piece.color].rook_grid_positions:
      if rgp in piece_man.pieces:
        var maybe_rook = piece_man.pieces[rgp]
        if maybe_rook.type == Enum.Ptype.ROOK and not maybe_rook.is_moved:
          # one of the same colored rooks has not moved
          var shift = -1 if piece.file - maybe_rook.file > 0 else 1
          if not range(piece.file + shift, maybe_rook.file, shift).any(func(file): return Vector2i(file, piece.row) in pieces):
            # all of the spaces between the king and the rook are open
            if not range(piece.file + shift, piece.file + 3*shift, shift).any(func(file): return is_threatened(file, piece.row, piece.player_id)):
              # the king will not be moving through, or into, check
              # move the king 2 towards the unmoved rook
              valid_castling_moves.append(Vector2i(piece.file + 2*shift, piece.row))
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
