extends Node2D
class_name Board2D

@onready var tmlayer = $TileMapLayer
@onready var highlights = $Highlights

func spawn_board():
  tmlayer.spawn_board()

func grid_to_local(grid_pos: Vector2i) -> Vector2:
  return tmlayer.grid_to_local(grid_pos)

func grid_to_global(grid_pos: Vector2i) -> Vector2:
  return tmlayer.grid_to_global(grid_pos)

func global_to_grid(global_pos: Vector2) -> Vector2i:
  return tmlayer.global_to_grid(global_pos)

func _ready() -> void:
  var game = get_parent()
  var piece_man = game.get_node("Piece_manager")

  piece_man.piece_drag_started.connect(_on_piece_drag_started)
  piece_man.piece_drag_ended.connect(_on_piece_drag_ended)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass

func _on_piece_drag_started(piece: Piece2D):
  highlights.add_highlight()

func _on_piece_drag_ended(piece: Piece2D):
  highlights.remove_highlight()
