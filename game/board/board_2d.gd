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

func global_to_grid(global_pos: Vector2) -> Vector2i:
  return tmlayer.global_to_grid(global_pos)

func is_inbounds(grid_pos: Vector2i) -> bool:
  return 0 <= grid_pos.x and grid_pos.x < FILES and 0 <= grid_pos.y and grid_pos.y < ROWS
