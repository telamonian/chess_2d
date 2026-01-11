extends Node2D

const PLAYER_SCENE = preload("res://game/player/player_2d.tscn")

var players: Dictionary[int, Player2D] = {}

func spawn_player(id: int, color: Enum.Pcolor):
  var player: Player2D = PLAYER_SCENE.instantiate()
  add_child(player)

  player.setup(id, color)
  players[player.id] = player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass
