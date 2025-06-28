import 'player.dart';
import 'word_pair.dart';
import 'vote.dart';

enum GameState {
  setup,
  roleDistribution,
  description,
  voting,
  results,
  gameOver,
}

class Game {
  List<Player> players;
  WordPair? currentWordPair;
  GameState gameState;
  int currentRound;
  List<Vote> currentVotes;
  String? eliminatedPlayerName;
  bool citizensWin;

  Game({
    this.players = const [],
    this.currentWordPair,
    this.gameState = GameState.setup,
    this.currentRound = 1,
    this.currentVotes = const [],
    this.eliminatedPlayerName,
    this.citizensWin = false,
  });

  Game copyWith({
    List<Player>? players,
    WordPair? currentWordPair,
    GameState? gameState,
    int? currentRound,
    List<Vote>? currentVotes,
    String? eliminatedPlayerName,
    bool? citizensWin,
  }) {
    return Game(
      players: players ?? this.players,
      currentWordPair: currentWordPair ?? this.currentWordPair,
      gameState: gameState ?? this.gameState,
      currentRound: currentRound ?? this.currentRound,
      currentVotes: currentVotes ?? this.currentVotes,
      eliminatedPlayerName: eliminatedPlayerName ?? this.eliminatedPlayerName,
      citizensWin: citizensWin ?? this.citizensWin,
    );
  }

  List<Player> get alivePlayers =>
      players.where((p) => !p.isEliminated).toList();

  List<Player> get aliveUndercover =>
      alivePlayers.where((p) => p.role == PlayerRole.undercover).toList();

  List<Player> get aliveCitizens =>
      alivePlayers.where((p) => p.role == PlayerRole.citizen).toList();
}
