class_name PlayerManager extends Object

var players: Dictionary[int, Player] = {}

func spawn_player(id: int, color: Enum.Pcolor, files: int, rows: int):
  var player = Player.new(id, color, files, rows)
  players[player.id] = player
