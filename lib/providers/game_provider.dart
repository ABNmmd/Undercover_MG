import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/game.dart';
import '../models/player.dart';
import '../models/vote.dart';
import '../data/word_pairs_data.dart';

class GameProvider with ChangeNotifier {
  Game _game = Game();
  int _currentPlayerIndex = 0;

  // Getters
  Game get game => _game;
  int get currentPlayerIndex => _currentPlayerIndex;

  Player? get currentPlayer {
    if (_currentPlayerIndex < _game.alivePlayers.length) {
      return _game.alivePlayers[_currentPlayerIndex];
    }
    return null;
  }

  bool get allPlayersVoted {
    return _game.alivePlayers.every((player) => player.hasVoted);
  }

  // Start a new game with player names
  void startGame(List<String> playerNames) {
    if (playerNames.length < 3 || playerNames.length > 12) {
      throw Exception('Player count must be between 3 and 12');
    }

    // Select random word pair
    final random = Random();
    final wordPair =
        WordPairData.wordPairs[random.nextInt(WordPairData.wordPairs.length)];

    // Shuffle players and assign roles
    final shuffledNames = List<String>.from(playerNames)..shuffle(random);
    final undercoverIndex = random.nextInt(shuffledNames.length);

    final players = shuffledNames.asMap().entries.map((entry) {
      final index = entry.key;
      final name = entry.value;

      if (index == undercoverIndex) {
        return Player(
          name: name,
          role: PlayerRole.undercover,
          word: wordPair.undercoverWord,
        );
      } else {
        return Player(
          name: name,
          role: PlayerRole.citizen,
          word: wordPair.citizenWord,
        );
      }
    }).toList();

    _game = Game(
      players: players,
      currentWordPair: wordPair,
      gameState: GameState.roleDistribution,
      currentRound: 1,
      currentVotes: [],
    );

    _currentPlayerIndex = 0;
    notifyListeners();
  }

  // Move to next player in role distribution
  void nextRoleDistribution() {
    if (_currentPlayerIndex < _game.players.length - 1) {
      _currentPlayerIndex++;
    } else {
      // All players have seen their roles, move to description phase
      _game = _game.copyWith(gameState: GameState.description);
      _currentPlayerIndex = 0;
    }
    notifyListeners();
  }

  // Move to next player in description phase
  void nextPlayerDescription() {
    if (_currentPlayerIndex < _game.alivePlayers.length - 1) {
      _currentPlayerIndex++;
    } else {
      // All players have described, move to voting phase
      startVoting();
    }
    notifyListeners();
  }

  // Get current player for description phase
  Player? get currentDescriptionPlayer {
    if (_currentPlayerIndex < _game.alivePlayers.length) {
      return _game.alivePlayers[_currentPlayerIndex];
    }
    return null;
  }

  // Check if all players have described
  bool get allPlayersDescribed {
    return _currentPlayerIndex >= _game.alivePlayers.length - 1;
  }

  // Start voting phase
  void startVoting() {
    // Reset voting status for all alive players
    final updatedPlayers = _game.players.map((player) {
      if (!player.isEliminated) {
        return player.copyWith(hasVoted: false);
      }
      return player;
    }).toList();

    _game = _game.copyWith(
      gameState: GameState.voting,
      players: updatedPlayers,
      currentVotes: [],
    );
    notifyListeners();
  }

  // Cast a vote
  void castVote(String voterName, String targetName) {
    // Remove any existing vote from this voter
    final updatedVotes = _game.currentVotes
        .where((vote) => vote.voterName != voterName)
        .toList();

    // Add new vote
    updatedVotes.add(Vote(voterName: voterName, targetName: targetName));

    // Mark voter as having voted
    final updatedPlayers = _game.players.map((player) {
      if (player.name == voterName) {
        return player.copyWith(hasVoted: true);
      }
      return player;
    }).toList();

    _game = _game.copyWith(currentVotes: updatedVotes, players: updatedPlayers);
    notifyListeners();
  }

  // Process voting results
  void processVotingResults() {
    final voteCount = <String, int>{};

    // Count votes
    for (final vote in _game.currentVotes) {
      voteCount[vote.targetName] = (voteCount[vote.targetName] ?? 0) + 1;
    }

    String? eliminatedPlayer;

    if (voteCount.isNotEmpty) {
      final maxVotes = voteCount.values.reduce((a, b) => a > b ? a : b);
      final mostVotedPlayers = voteCount.entries
          .where((entry) => entry.value == maxVotes)
          .map((entry) => entry.key)
          .toList();

      // Only eliminate if there's no tie
      if (mostVotedPlayers.length == 1) {
        eliminatedPlayer = mostVotedPlayers.first;

        // Eliminate the player
        final updatedPlayers = _game.players.map((player) {
          if (player.name == eliminatedPlayer) {
            return player.copyWith(isEliminated: true);
          }
          return player;
        }).toList();

        _game = _game.copyWith(players: updatedPlayers);
      }
    }

    _game = _game.copyWith(
      gameState: GameState.results,
      eliminatedPlayerName: eliminatedPlayer,
    );

    // Check win condition
    _checkWinCondition();
    notifyListeners();
  }

  // Check if game is over
  void _checkWinCondition() {
    final aliveUndercover = _game.aliveUndercover;

    // Citizens win if all undercover are eliminated
    if (aliveUndercover.isEmpty) {
      _game = _game.copyWith(gameState: GameState.gameOver, citizensWin: true);
      return;
    }

    // Undercover wins if only 2 players remain (1 undercover + 1 citizen)
    if (_game.alivePlayers.length == 2 && aliveUndercover.length == 1) {
      _game = _game.copyWith(gameState: GameState.gameOver, citizensWin: false);
      return;
    }
  }

  // Continue to next round
  void nextRound() {
    _game = _game.copyWith(
      gameState: GameState.description,
      currentRound: _game.currentRound + 1,
      currentVotes: [],
      eliminatedPlayerName: null,
    );

    // Reset voting status for alive players
    final updatedPlayers = _game.players.map((player) {
      if (!player.isEliminated) {
        return player.copyWith(hasVoted: false);
      }
      return player;
    }).toList();

    _game = _game.copyWith(players: updatedPlayers);
    _currentPlayerIndex = 0;
    notifyListeners();
  }

  // Reset game to initial state
  void resetGame() {
    _game = Game();
    _currentPlayerIndex = 0;
    notifyListeners();
  }

  // Get vote count for display
  Map<String, int> getVoteCount() {
    final voteCount = <String, int>{};
    for (final vote in _game.currentVotes) {
      voteCount[vote.targetName] = (voteCount[vote.targetName] ?? 0) + 1;
    }
    return voteCount;
  }

  // Check if player name is valid
  bool isValidPlayerName(String name) {
    return name.trim().isNotEmpty && name.trim().length <= 15;
  }

  // Check if player count is valid
  bool isValidPlayerCount(int count) {
    return count >= 3 && count <= 12;
  }
}
