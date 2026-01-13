extends Node2D

signal piece_drag_started(piece: Piece2D)
signal piece_drag_ended(piece: Piece2D)

const PIECE_SCENE = preload("res://game/piece/piece_2d.tscn")

var pieces: Dictionary[Vector2i, Piece2D] = {}

@onready var game = get_parent()

func remove_piece(grid_pos: Vector2i):
  var piece: Piece2D = pieces.get(grid_pos)

  pieces.erase(grid_pos)
  remove_child(piece)
  piece.queue_free()

func spawn_piece(color: Enum.Pcolor, type: Enum.Ptype, grid_pos: Vector2i) -> Piece2D:
  # need to use PIECE_SCENE.instantiate() here instead of eg Piece2D.new()
  # see: https://www.reddit.com/r/godot/comments/17o1mkz/comment/k7vhc0m
  var piece = PIECE_SCENE.instantiate()
  add_child(piece)

  piece.setup(color, type, grid_pos, game.board.grid_to_local(grid_pos))
  pieces[grid_pos] = piece

  return piece

func spawn_back(row: int, color: Enum.Pcolor):
  # rooks
  for i in [0, 7]:
    spawn_piece(color, Enum.Ptype.ROOK, Vector2i(i, row))

  # knights
  for i in [1, 6]:
    spawn_piece(color, Enum.Ptype.KNIGHT, Vector2i(i, row))

  # bishops
  for i in [2, 5]:
    spawn_piece(color, Enum.Ptype.BISHOP, Vector2i(i, row))

  # royals
  spawn_piece(color, Enum.Ptype.QUEEN, Vector2i(3, row))
  spawn_piece(color, Enum.Ptype.KING, Vector2i(4, row))

func spawn_front(row: int, color: Enum.Pcolor):
  # pawns
  for i in range(8):
    spawn_piece(color, Enum.Ptype.PAWN, Vector2i(i, row))

func spawn_pieces_for_player(player: Player2D):
  spawn_back(player.row_back, player.color)
  spawn_front(player.row_front, player.color)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  piece_drag_ended.connect(_on_piece_drag_ended)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass


func _on_piece_drag_ended(piece: Piece2D) -> void:
  var color = piece.color
  var type = piece.type
  var grid_pos = piece.grid_position
  var new_grid_pos = game.board.global_to_grid(piece.position)

  if grid_pos != new_grid_pos:
    # piece has actually moved
    if new_grid_pos in pieces:
      remove_piece(new_grid_pos)

    remove_piece(grid_pos)
    var new_piece = spawn_piece(color, type, new_grid_pos)
    new_piece.is_moved = true
