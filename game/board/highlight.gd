# adapted from https://forum.godotengine.org/t/tile-outline-for-tilesets/28513/4
extends Node2D
class_name BoardHighlight

@export var tile_map: TileMapLayer:
  set (x):
    tile_map = x
    queue_redraw()

@export var grid_color: Color:
  set (x):
    grid_color = x
    queue_redraw()

@export var squares: Array[Vector2i]:
  set (x):
    squares = x
    squares_to_coords()
    queue_redraw()

var vertical_coords: PackedVector2Array;
var horizontal_coords: PackedVector2Array;

func _init(new_squares: Array[Vector2i], new_grid_color: Color, new_tile_map: TileMapLayer):
  tile_map = new_tile_map
  grid_color = new_grid_color
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

#func _ready() -> void:
  #var tilemap_rect := tile_map.get_used_rect();
  #var tilemap_cell_size := tile_map.tile_set.tile_size;
#
  #for y: int in range(0, tilemap_rect.size.y):
    #horizontal_points.append(Vector2(0, y * tilemap_cell_size.y))
    #horizontal_points.append(Vector2(tilemap_rect.size.x * tilemap_cell_size.x, y * tilemap_cell_size.y))
#
  #for x in range(0, tilemap_rect.size.x):
    #vertical_points.append(Vector2(x * tilemap_cell_size.x, 0))
    #vertical_points.append(Vector2(x * tilemap_cell_size.x, tilemap_rect.size.y * tilemap_cell_size.y))

func _draw() -> void:
  draw_multiline(vertical_coords, grid_color, 10.0);
  draw_multiline(horizontal_coords, grid_color, 10.0);
