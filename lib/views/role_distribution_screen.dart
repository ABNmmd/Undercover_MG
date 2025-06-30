import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../models/player.dart';
import '../widgets/widgets.dart';

class RoleDistributionScreen extends StatefulWidget {
  const RoleDistributionScreen({super.key});

  @override
  State<RoleDistributionScreen> createState() => _RoleDistributionScreenState();
}

class _RoleDistributionScreenState extends State<RoleDistributionScreen> {
  String? selectedPlayerName;
  bool showingRole = false;

  void _selectPlayer(String playerName) {
    setState(() {
      selectedPlayerName = playerName;
      showingRole = false;
    });
  }

  void _showPlayerRole() {
    if (selectedPlayerName != null) {
      setState(() {
        showingRole = true;
      });
    }
  }

  void _confirmAndNext() {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    gameProvider.nextRoleDistribution();
    setState(() {
      selectedPlayerName = null;
      showingRole = false;
    });
  }

  void _showQuitGameDialog(BuildContext context, GameProvider gameProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          content: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 2,
              ),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.orange,
                  size: 48,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Quit Game?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Are you sure you want to quit the current game?\nAll progress will be lost.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(
                              color: Colors.white.withOpacity(0.5),
                              width: 1,
                            ),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          gameProvider.resetGame();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 2,
                        ),
                        child: const Text(
                          'Quit Game',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text(
                'Role Distribution - Round ${gameProvider.game.currentRound}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  onPressed: () => _showQuitGameDialog(context, gameProvider),
                  icon: const Icon(
                    Icons.exit_to_app,
                    color: Colors.white,
                    size: 24,
                  ),
                  tooltip: 'Quit Game',
                ),
              ],
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    // Instructions
                    if (selectedPlayerName == null)
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.info_outline,
                              color: Colors.white,
                              size: 32,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Each player should view their role privately.\nTap your name card below:',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                    if (selectedPlayerName == null) const SizedBox(height: 30),

                    // Player cards or role display
                    selectedPlayerName == null
                        ? _buildPlayerCards(gameProvider)
                        : showingRole
                        ? _buildRoleDisplay(gameProvider)
                        : _buildConfirmationScreen(),
                        
                    // Add some bottom padding for better scrolling experience
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlayerCards(GameProvider gameProvider) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Calculate card width for 2 columns with spacing
          final cardWidth = (constraints.maxWidth - 16) / 2; // 16 for spacing between cards
          final cardHeight = cardWidth / 0.85; // aspect ratio 0.85
          
          return Wrap(
            spacing: 16,
            runSpacing: 16,
            children: gameProvider.game.players.asMap().entries.map((entry) {
              final index = entry.key;
              final player = entry.value;
              final hasViewed = index < gameProvider.currentPlayerIndex;
              
              return SizedBox(
                width: cardWidth,
                height: cardHeight,
                child: PlayerCard(
                  playerName: player.name,
                  onTap: hasViewed ? null : () => _selectPlayer(player.name),
                  isViewed: hasViewed,
                  isCurrentPlayer: index == gameProvider.currentPlayerIndex,
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  Widget _buildConfirmationScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Column(
              children: [
                Icon(Icons.person_2, size: 80, color: Colors.white),
                const SizedBox(height: 20),
                Text(
                  selectedPlayerName!,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Are you ready to see your role?',
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Row(
              children: [
                // X icon button for cancel
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        selectedPlayerName = null;
                      });
                    },
                    icon: const Icon(Icons.close, color: Colors.grey, size: 28),
                  ),
                ),
                const SizedBox(width: 20),
                // Large prominent Show Role button
                Expanded(
                  child: Container(
                    height: 60,
                    child: GameButton(
                      text: 'SHOW ROLE',
                      icon: Icons.visibility,
                      onPressed: _showPlayerRole,
                      gradientColors: const [
                        Color(0xFF4CAF50),
                        Color(0xFF45A049),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleDisplay(GameProvider gameProvider) {
    final player = gameProvider.game.players.firstWhere(
      (p) => p.name == selectedPlayerName,
    );

    final isUndercover = player.role == PlayerRole.undercover;
    final roleColor = isUndercover ? Colors.red : Colors.blue;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(36),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: roleColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: roleColor.withOpacity(0.5), width: 2),
              ),
              child: Column(
                children: [
                  Icon(
                    isUndercover ? Icons.visibility : Icons.shield,
                    size: 60,
                    color: roleColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'You are a',
                    style: const TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    isUndercover ? 'UNDERCOVER' : 'CITIZEN',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: roleColor,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Your word is:',
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: roleColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      player.word,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: GameButton(
                text: 'GOT IT!',
                icon: Icons.check,
                onPressed: _confirmAndNext,
                gradientColors: const [Color(0xFF4CAF50), Color(0xFF45A049)],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
