extends Node2D

@onready var player_man = $Player_Manager
@onready var piece_man = $Piece_Manager
@onready var board = $Board_2d

func spawn_game():
  board.spawn_board(8, 8)

  player_man.spawn_player(0, Enum.Pcolor.WHITE)
  player_man.spawn_player(1, Enum.Pcolor.BLACK)

  for player in player_man.players.values():
    piece_man.spawn_pieces_for_player(player)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  spawn_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass
