extends Node2D

@onready var tmlayer = $TileMapLayer
@onready var man = $Piece_Manager

func grid_to_local(grid_pos: Vector2i) -> Vector2:
  return tmlayer.grid_to_local(grid_pos)

func grid_to_global(grid_pos: Vector2i) -> Vector2:
  return tmlayer.grid_to_global(grid_pos)

func global_to_grid(global_pos: Vector2) -> Vector2i:
  return tmlayer.global_to_grid(global_pos)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  tmlayer.init_board()

  # rooks
  man.spawn_piece(Enum.Pcolor.WHITE, Enum.Ptype.ROOK, Vector2i(0, 0))
  man.spawn_piece(Enum.Pcolor.WHITE, Enum.Ptype.ROOK, Vector2i(7, 0))
  
  man.spawn_piece(Enum.Pcolor.BLACK, Enum.Ptype.ROOK, Vector2i(7, 7))
  man.spawn_piece(Enum.Pcolor.BLACK, Enum.Ptype.ROOK, Vector2i(0, 7))
  
  # knights
  man.spawn_piece(Enum.Pcolor.WHITE, Enum.Ptype.KNIGHT, Vector2i(1, 0))
  man.spawn_piece(Enum.Pcolor.WHITE, Enum.Ptype.KNIGHT, Vector2i(6, 0))
  
  man.spawn_piece(Enum.Pcolor.BLACK, Enum.Ptype.KNIGHT, Vector2i(1, 7))
  man.spawn_piece(Enum.Pcolor.BLACK, Enum.Ptype.KNIGHT, Vector2i(6, 7))
  
  # bishops
  man.spawn_piece(Enum.Pcolor.WHITE, Enum.Ptype.BISHOP, Vector2i(2, 0))
  man.spawn_piece(Enum.Pcolor.WHITE, Enum.Ptype.BISHOP, Vector2i(5, 0))
  
  man.spawn_piece(Enum.Pcolor.BLACK, Enum.Ptype.BISHOP, Vector2i(2, 7))
  man.spawn_piece(Enum.Pcolor.BLACK, Enum.Ptype.BISHOP, Vector2i(5, 7))
  
  # royals
  man.spawn_piece(Enum.Pcolor.WHITE, Enum.Ptype.QUEEN, Vector2i(3, 0))
  man.spawn_piece(Enum.Pcolor.WHITE, Enum.Ptype.KING, Vector2i(4, 0))
  
  man.spawn_piece(Enum.Pcolor.BLACK, Enum.Ptype.QUEEN, Vector2i(3, 7))
  man.spawn_piece(Enum.Pcolor.BLACK, Enum.Ptype.KING, Vector2i(4, 7))
    
  for file in range(8):
    man.spawn_piece(Enum.Pcolor.WHITE, Enum.Ptype.PAWN, Vector2i(file, 1))    
    man.spawn_piece(Enum.Pcolor.BLACK, Enum.Ptype.PAWN, Vector2i(file, 6))
  

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass
