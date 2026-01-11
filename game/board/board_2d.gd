extends Node2D
class_name Board2D

@onready var tmlayer = $TileMapLayer

func spawn_board():
  tmlayer.spawn_board()

func grid_to_local(grid_pos: Vector2i) -> Vector2:
  return tmlayer.grid_to_local(grid_pos)

func grid_to_global(grid_pos: Vector2i) -> Vector2:
  return tmlayer.grid_to_global(grid_pos)

func global_to_grid(global_pos: Vector2) -> Vector2i:
  return tmlayer.global_to_grid(global_pos)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass
