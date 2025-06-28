import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../models/game.dart';
import 'player_setup_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        return Scaffold(body: _buildGameContent(context, gameProvider));
      },
    );
  }

  Widget _buildGameContent(BuildContext context, GameProvider gameProvider) {
    switch (gameProvider.game.gameState) {
      case GameState.setup:
        // Check if we should show setup screen or home screen
        if (gameProvider.game.players.isEmpty) {
          return _buildHomeScreen(context, gameProvider);
        } else {
          return const PlayerSetupScreen();
        }
      case GameState.roleDistribution:
        return _buildRoleDistributionScreen(context, gameProvider);
      case GameState.description:
        return _buildDescriptionScreen(context, gameProvider);
      case GameState.voting:
        return _buildVotingScreen(context, gameProvider);
      case GameState.results:
        return _buildResultsScreen(context, gameProvider);
      case GameState.gameOver:
        return _buildGameOverScreen(context, gameProvider);
    }
  }

  Widget _buildHomeScreen(BuildContext context, GameProvider gameProvider) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Game Logo/Title
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
                    Icon(Icons.person_2, size: 100, color: Colors.white),
                    const SizedBox(height: 24),
                    const Text(
                      'UNDERCOVER',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Social Deduction Game',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white70,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 60),

              // Start Play Button
              Container(
                width: double.infinity,
                height: 70,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
                  ),
                  borderRadius: BorderRadius.circular(35),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(35),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const PlayerSetupScreen(),
                        ),
                      );
                    },
                    child: const Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.play_arrow, color: Colors.white, size: 32),
                          SizedBox(width: 12),
                          Text(
                            'START PLAYING',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Player count info
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Text(
                  '3-12 Players',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleDistributionScreen(
    BuildContext context,
    GameProvider gameProvider,
  ) {
    return const Center(
      child: Text(
        'Role Distribution Screen\n(Coming Soon)',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 24),
      ),
    );
  }

  Widget _buildDescriptionScreen(
    BuildContext context,
    GameProvider gameProvider,
  ) {
    return const Center(
      child: Text(
        'Description Screen\n(Coming Soon)',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 24),
      ),
    );
  }

  Widget _buildVotingScreen(BuildContext context, GameProvider gameProvider) {
    return const Center(
      child: Text(
        'Voting Screen\n(Coming Soon)',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 24),
      ),
    );
  }

  Widget _buildResultsScreen(BuildContext context, GameProvider gameProvider) {
    return const Center(
      child: Text(
        'Results Screen\n(Coming Soon)',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 24),
      ),
    );
  }

  Widget _buildGameOverScreen(BuildContext context, GameProvider gameProvider) {
    return const Center(
      child: Text(
        'Game Over Screen\n(Coming Soon)',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}
