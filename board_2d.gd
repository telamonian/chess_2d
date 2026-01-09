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
  
  for file in range(8):
    man.spawn_piece(Enum.Pcolor.WHITE, Enum.Ptype.PAWN, Vector2i(file, 1))
    man.spawn_piece(Enum.Pcolor.BLACK, Enum.Ptype.PAWN, Vector2i(file, 6))
  
  tmlayer.init_board()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass
