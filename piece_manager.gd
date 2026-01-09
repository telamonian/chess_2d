extends Node2D

const PIECE_SCENE = preload("res://piece_2d.tscn")
var pieces = {}

@onready var board = get_parent()

func spawn_piece(color: Enum.Pcolor, type: Enum.Ptype, grid_pos: Vector2i):
  var piece = PIECE_SCENE.instantiate()
  add_child(piece)
  
  var pos = board.grid_to_local(grid_pos)
  piece.setup(color, type, grid_pos, pos)
  
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
