extends TileMapLayer

const DARK_SQUARE = Vector2i(0, 0)
const DARK_SQUARE_SOURCE = 2
const LIGHT_SQUARE = Vector2i(0, 0)
const LIGHT_SQUARE_SOURCE = 1

var FILES: int
var ROWS: int

func spawn_board(files: int, rows: int):
  FILES = files
  ROWS = rows

  for file in range(FILES):
    for row in range(ROWS):
      var parity = (file % 2 + row % 2) % 2
      var square = LIGHT_SQUARE if parity else DARK_SQUARE
      var source = LIGHT_SQUARE_SOURCE if parity else DARK_SQUARE_SOURCE

      var inverse_row = ROWS - 1 - row
      # use inverse row to paint the squares bottom-to-top
      set_cell(Vector2(file, inverse_row), source, square)

func grid_to_local(grid_pos: Vector2i) -> Vector2:
  var row_rev_grid_pos = Vector2i(grid_pos.x, ROWS - 1 - grid_pos.y)
  return map_to_local(row_rev_grid_pos)

#func grid_to_global(grid_pos: Vector2i) -> Vector2:
  #var row_rev_grid_pos = Vector2i(grid_pos.x, ROWS - 1 - grid_pos.y)
  #return to_global(map_to_local(row_rev_grid_pos))
#
#func global_to_grid(global_pos: Vector2) -> Vector2i:
  #var row_rev_grid_pos = local_to_map(to_local(global_pos))
  #return Vector2i(row_rev_grid_pos.x, ROWS - 1 - row_rev_grid_pos.y)

func local_to_grid(local_pos: Vector2) -> Vector2i:
  var row_rev_grid_pos = local_to_map(local_pos)
  return Vector2i(row_rev_grid_pos.x, ROWS - 1 - row_rev_grid_pos.y)
