extends Node2D
class_name Player2D

var id: int
var color: Enum.Pcolor
var is_in_check: bool = false

var row_back: int
var row_front: int
var row_promote: int
var pawn_dir: int
var rook_grid_positions: Array[Vector2i]

func setup(new_id: int, new_color: Enum.Pcolor, files: int, rows: int):
  id = new_id
  color = new_color

  if color == Enum.Pcolor.WHITE:
    row_back = 0
    row_front = 1
    row_promote = rows - 1
    pawn_dir = 1
    rook_grid_positions = [Vector2i(0, 0), Vector2i(files - 1, 0)]
  elif color == Enum.Pcolor.BLACK:
    row_back = rows - 1
    row_front = rows - 2
    row_promote = 0
    pawn_dir = -1
    rook_grid_positions = [Vector2i(0, rows - 1), Vector2i(files - 1, rows -1)]
