# adapted from https://forum.godotengine.org/t/tile-outline-for-tilesets/28513/4
extends Node2D
class_name BoardHighlight

var square_highlight_color_opt: Opt.Option = Opt.set_option("game", "square_highlight", Color(1.0, .5, 0.259, 1.0))

@export var tile_map: TileMapLayer:
  set(x):
    tile_map = x
    queue_redraw()

@export var grid_color: Color:
  set(x):
    grid_color = square_highlight_color_opt.value
    queue_redraw()

func _set_grid_color(opt: Opt.Option):
  grid_color = opt.value

@export var squares: Array[Vector2i]:
  set(x):
    squares = x
    squares_to_coords()
    queue_redraw()

var vertical_coords: PackedVector2Array;
var horizontal_coords: PackedVector2Array;

func _init(new_squares: Array[Vector2i], new_grid_color: Color, new_tile_map: TileMapLayer):
  _set_grid_color(square_highlight_color_opt)
  square_highlight_color_opt.changed.connect(_set_grid_color)

  tile_map = new_tile_map
  squares = new_squares

func squares_to_coords():
  var square_size := tile_map.tile_set.tile_size

  for square in squares:
    var center: Vector2 = tile_map.grid_to_local(square)

    for x in [-square_size.x/2.0, square_size.x/2.0]:
      for y in [-square_size.y/2.0, square_size.y/2.0]:
        vertical_coords.append(Vector2(center.x + x, center.y + y))

    for y in [-square_size.y/2.0, square_size.y/2.0]:
      for x in [-square_size.x/2.0, square_size.x/2.0]:
        horizontal_coords.append(Vector2(center.x + x, center.y + y))

func _draw() -> void:
  draw_multiline(vertical_coords, grid_color, 10.0);
  draw_multiline(horizontal_coords, grid_color, 10.0);
