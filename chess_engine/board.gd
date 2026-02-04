class_name Board extends Object

var FILES: int
var ROWS: int

func _init(files: int, rows: int):
  FILES = files
  ROWS = rows

func is_inbounds(grid_pos: Vector2i) -> bool:
  return 0 <= grid_pos.x and grid_pos.x < FILES and 0 <= grid_pos.y and grid_pos.y < ROWS
