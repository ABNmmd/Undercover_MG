enum PlayerRole { citizen, undercover }

class Player {
  final String name;
  final PlayerRole role;
  final String word;
  bool isEliminated;
  bool hasVoted;

  Player({
    required this.name,
    required this.role,
    required this.word,
    this.isEliminated = false,
    this.hasVoted = false,
  });

  Player copyWith({
    String? name,
    PlayerRole? role,
    String? word,
    bool? isEliminated,
    bool? hasVoted,
  }) {
    return Player(
      name: name ?? this.name,
      role: role ?? this.role,
      word: word ?? this.word,
      isEliminated: isEliminated ?? this.isEliminated,
      hasVoted: hasVoted ?? this.hasVoted,
    );
  }
}
