class_name Player2D extends Node2D

const PLAYER_SCENE: PackedScene = preload("res://game/player/player_2d.tscn")

var engine_player: Player

static func new_player(eng_player: Player) -> Player2D:
  var new_player_2d := PLAYER_SCENE.instantiate()
  new_player_2d.setup(eng_player)

  return new_player_2d

var id: int:
  get():
    return engine_player.id
var color: Enum.Pcolor:
  get():
    return engine_player.color

var row_back: int:
  get():
    return engine_player.row_back
var row_front: int:
  get():
    return engine_player.row_front
var row_promote: int:
  get():
    return engine_player.row_promote
var pawn_dir: int:
  get():
    return engine_player.pawn_dir
var rook_grid_positions: Array[Vector2i]:
  get():
    return engine_player.rook_grid_positions

func setup(eng_player: Player):
  engine_player = eng_player
