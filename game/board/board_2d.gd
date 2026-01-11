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

  man.spawn_back(0, Enum.Pcolor.WHITE)
  man.spawn_front(1, Enum.Pcolor.WHITE)

  man.spawn_back(7, Enum.Pcolor.BLACK)
  man.spawn_front(6, Enum.Pcolor.BLACK)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass
