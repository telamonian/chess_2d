class_name ChessEngine extends Object

signal rook_castled(rook_grid_pos: Vector2i, new_rook_grid_pos: Vector2i)
signal pawn_taken_enpassant(taken_pawn_pos: Vector2i)

var FILES: int
var ROWS: int

var board: Board = null
var piece_man: PieceManager = null
var player_man: PlayerManager = null

var passantable_position = null #: Vector2i = null

func setup(files: int = 8, rows: int = 8):
  FILES = files
  ROWS = rows

  if board != null:
    board.free()
  if piece_man != null:
    piece_man.free()
  if player_man != null:
    player_man.free()

  board = Board.new(FILES, ROWS)
  piece_man = PieceManager.new()
  player_man = PlayerManager.new()

  passantable_position = null

func spawn_game(files: int = 8, rows: int = 8):
  _spawn_game(files, rows)

  # spawn default pieces
  for player in player_man.players.values():
    piece_man.spawn_pieces_for_player(player)

func restore_game_state(piece_resources: Array[Piece.PieceResource], files: int = 8, rows: int = 8):
  _spawn_game(files, rows)

  # restore the pieces decribed in the piece_resources
  for pr in piece_resources:
    var player = player_man.players[pr.player_id]
    piece_man.spawn_piece(player.id, player.pawn_dir, player.color, pr.type, pr.grid_position)

func _spawn_game(files: int = 8, rows: int = 8):
  setup(files, rows)

  player_man.spawn_player(0, Enum.Pcolor.WHITE, FILES, ROWS)
  player_man.spawn_player(1, Enum.Pcolor.BLACK, FILES, ROWS)

func get_game_state() -> Array[Piece.PieceResource]:
  return piece_man.get_resources()

func move_piece(grid_pos: Vector2i, new_grid_pos: Vector2i) -> bool:
  var piece = piece_man.pieces[grid_pos]
  var player = player_man.players[piece.player_id]
  var valid_moves = get_valid_moves(piece)

  if passantable_position != null:
    # there is a passantable pawn
    var passantable_pawn = piece_man.pieces[passantable_position]
    if passantable_pawn.player_id == player.id:
      # reset passantable if the player who owns the passantable_pawn has moved again
      passantable_position = null

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
        rook_castled.emit(rook_grid_pos, new_rook_grid_pos)

        return true
    Enum.Ptype.PAWN:
      if passantable_position != null:
        var valid_passant_moves = get_valid_passant_moves(piece)
        if new_grid_pos in valid_passant_moves:
          piece_man.move_piece(grid_pos, new_grid_pos)
          piece_man.remove_piece(passantable_position)
          pawn_taken_enpassant.emit(passantable_position)

          passantable_position = null
          return true

  if new_grid_pos in valid_moves:
    if piece.type == Enum.Ptype.PAWN:
      if not piece.is_moved and absi(grid_pos.y - new_grid_pos.y) == 2:
        passantable_position = new_grid_pos

    # the move is valid, finalize the move
    piece_man.move_piece(grid_pos, new_grid_pos)
    return true
  else:
    # the move is invalid
    return false

func is_threatened(file: int, row: int, player_id: int) -> bool:
  var pieces = piece_man.pieces
  var player = player_man.players[player_id]

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
    for move in Piece.moves_knight(file, row) if ptype == Enum.Ptype.KNIGHT else Piece.moves_king(file, row):
      if board.is_inbounds(move):
        if move in pieces:
          var potential_threat = pieces[move]
          if potential_threat.color != player.color and potential_threat.type == ptype:
            return true

  # check for bishop, rook, and queen threats
  for ptype in [Enum.Ptype.BISHOP, Enum.Ptype.ROOK]:
    for run in Piece.moves_bishop(file, row) if ptype == Enum.Ptype.BISHOP else Piece.moves_rook(file, row):
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
  var king = piece_man.kings[player_id]
  return is_threatened(king.file, king.row, player_id)

func filter_checked(piece: Piece, moves: Array[Vector2i]) -> Array[Vector2i]:
  var player_id = piece.player_id
  var original_state = get_game_state()
  var test_engine = ChessEngine.new()

  var filtered: Array[Vector2i] = []
  for move in moves:
    test_engine.restore_game_state(original_state, FILES, ROWS)
    test_engine.piece_man.move_piece(piece.grid_position, move)
    if not test_engine.is_checked(player_id):
      filtered.append(move)

  return filtered

func get_valid_moves(piece: Piece) -> Array[Vector2i]:
  var pieces = piece_man.pieces
  var player = player_man.players[piece.player_id]
  var raw_moves = piece.get_moves()
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

func get_valid_castling_moves(piece: Piece) -> Array[Vector2i]:
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

func get_valid_passant_moves(piece: Piece) -> Array[Vector2i]:
  var valid_passant_moves: Array[Vector2i] = []
  if passantable_position != null:
    # there is a en passantable pawn
    if piece.grid_position.y == passantable_position.y and absi(piece.grid_position.x - passantable_position.x) == 1:
      # piece is next to the passantable pawn
      var post_passant_pos = Vector2i(passantable_position.x, passantable_position.y + piece.pawn_dir)
      valid_passant_moves.append(post_passant_pos)

      # TODO: is checking for the emptiness of the post-passant position necessary? I'm pretty sure no
      #if post_passant_pos not in piece_man.pieces:
        ## the post-passant position is not occupied by another piece
        #valid_passant_moves.append(post_passant_pos)

  return valid_passant_moves
