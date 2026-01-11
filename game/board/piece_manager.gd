extends Node2D

signal piece_drag_ended(piece: Piece2D)

const PIECE_SCENE = preload("res://game/piece/piece_2d.tscn")

var pieces: Dictionary[Vector2i, Piece2D] = {}

@onready var board = get_parent()

func remove_piece(grid_pos: Vector2i):
  var piece: Piece2D = pieces.get(grid_pos)
  
  pieces.erase(grid_pos)
  remove_child(piece)
  piece.queue_free()

func spawn_piece(color: Enum.Pcolor, type: Enum.Ptype, grid_pos: Vector2i):
  var piece = PIECE_SCENE.instantiate()
  add_child(piece)
  
  piece.setup(color, type, grid_pos)
  pieces[grid_pos] = piece

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  pass
  #spawn_piece(Enum.Pcolor.WHITE, Enum.Ptype.PAWN, Vector2i(1,1))
  #spawn_piece(Enum.Pcolor.WHITE, Enum.Ptype.PAWN, Vector2i(1,3))
  #
  #spawn_piece(Enum.Pcolor.BLACK, Enum.Ptype.PAWN, Vector2i(6,1))
  #spawn_piece(Enum.Pcolor.BLACK, Enum.Ptype.PAWN, Vector2i(6,3))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass


func _on_piece_drag_ended(piece: Piece2D) -> void:
  var color = piece.color
  var type = piece.type
  var grid_pos = piece.grid_position
  var new_grid_pos = board.global_to_grid(piece.position)
  
  if new_grid_pos in pieces:
    remove_piece(new_grid_pos)
    
  remove_piece(grid_pos)
  spawn_piece(color, type, new_grid_pos)
