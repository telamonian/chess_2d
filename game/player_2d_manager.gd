extends Node2D

const PLAYER_SCENE = preload("res://game/player/player_2d.tscn")

var players: Dictionary[int, Player2D] = {}

func spawn_player(engine_player: Player):
  var player: Player2D = PLAYER_SCENE.instantiate()
  add_child(player)

  player.setup(engine_player)
  players[player.id] = player
