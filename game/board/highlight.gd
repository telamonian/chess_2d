extends Node2D
class_name BoardHighlight

@export var tile_map: TileMapLayer:
  set (x):
    tile_map = x;
    queue_redraw();

@export var grid_color: Color:
  set (x):
    grid_color = x;
    queue_redraw();

var vertical_points: PackedVector2Array;
var horizontal_points: PackedVector2Array;

func _init(new_tile_map: TileMapLayer, new_grid_color: Color):
  tile_map = new_tile_map
  grid_color = new_grid_color

func _ready() -> void:
  var tilemap_rect := tile_map.get_used_rect();
  var tilemap_cell_size := tile_map.tile_set.tile_size;

  for y: int in range(0, tilemap_rect.size.y):
    horizontal_points.append(Vector2(0, y * tilemap_cell_size.y))
    horizontal_points.append(Vector2(tilemap_rect.size.x * tilemap_cell_size.x, y * tilemap_cell_size.y))

  for x in range(0, tilemap_rect.size.x):
    vertical_points.append(Vector2(x * tilemap_cell_size.x, 0))
    vertical_points.append(Vector2(x * tilemap_cell_size.x, tilemap_rect.size.y * tilemap_cell_size.y))

func _draw() -> void:
  draw_multiline(horizontal_points, grid_color);
  draw_multiline(vertical_points, grid_color);
