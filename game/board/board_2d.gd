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

#func grid_to_global(grid_pos: Vector2i) -> Vector2:
  #return tmlayer.grid_to_global(grid_pos)
#
#func global_to_grid(global_pos: Vector2) -> Vector2i:
  #return tmlayer.global_to_grid(global_pos)

func local_to_grid(grid_pos: Vector2i) -> Vector2:
  return tmlayer.local_to_grid(grid_pos)
