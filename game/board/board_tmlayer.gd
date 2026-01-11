extends TileMapLayer

const FILES = 8
const ROWS = 8

const DARK_SQUARE = Vector2i(0, 0)
const DARK_SQUARE_SOURCE = 2
const LIGHT_SQUARE = Vector2i(0, 0)
const LIGHT_SQUARE_SOURCE = 1

func init_board():
  for file in range(FILES):
    for row in range(ROWS):
      var parity = (file % 2 + row % 2) % 2
      var square = LIGHT_SQUARE if parity else DARK_SQUARE
      var source = LIGHT_SQUARE_SOURCE if parity else DARK_SQUARE_SOURCE
      
      var inverse_row = 7 - row
      # use inverse row to paint the squares bottom-to-top
      set_cell(Vector2(file, inverse_row), source, square)

func grid_to_local(grid_pos: Vector2i) -> Vector2:
  var row_rev_grid_pos = Vector2i(grid_pos.x, ROWS - 1 - grid_pos.y)
  return map_to_local(row_rev_grid_pos)

func grid_to_global(grid_pos: Vector2i) -> Vector2:
  var row_rev_grid_pos = Vector2i(grid_pos.x, ROWS - 1 - grid_pos.y)
  return to_global(map_to_local(row_rev_grid_pos))

func global_to_grid(global_pos: Vector2) -> Vector2i:
  var row_rev_grid_pos = local_to_map(to_local(global_pos))
  return Vector2i(row_rev_grid_pos.x, ROWS - 1 - row_rev_grid_pos.y)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass
