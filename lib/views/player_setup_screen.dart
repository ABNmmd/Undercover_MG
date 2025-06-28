import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../widgets/widgets.dart';
import '../core/toast_helper.dart';

class PlayerSetupScreen extends StatefulWidget {
  const PlayerSetupScreen({super.key});

  @override
  State<PlayerSetupScreen> createState() => _PlayerSetupScreenState();
}

class _PlayerSetupScreenState extends State<PlayerSetupScreen> {
  final List<TextEditingController> _controllers = [];
  int _playerCount = 3;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _initializeControllers() {
    _controllers.clear();
    for (int i = 0; i < _playerCount; i++) {
      _controllers.add(TextEditingController());
    }
  }

  void _updatePlayerCount(int newCount) {
    setState(() {
      _playerCount = newCount;
      _initializeControllers();
    });
  }

  void _startGame() {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    final playerNames = _controllers
        .map((controller) => controller.text.trim())
        .where((name) => name.isNotEmpty)
        .toList();

    // Check if we have at least 3 players
    if (playerNames.length < 3) {
      ToastHelper.showError('Please enter at least 3 player names');
      return;
    }

    // Check if we have exactly the expected number of players
    if (playerNames.length != _playerCount) {
      ToastHelper.showError('Please fill in all player names');
      return;
    }

    // Check for duplicate names
    if (playerNames.length != playerNames.toSet().length) {
      ToastHelper.showError('Player names must be unique');
      return;
    }

    // Validate individual names
    for (String name in playerNames) {
      if (name.length < 2) {
        ToastHelper.showError(
          'Player names must be at least 2 characters long',
        );
        return;
      }
      if (name.length > 15) {
        ToastHelper.showError('Player names must be 15 characters or less');
        return;
      }
    }

    try {
      gameProvider.startGame(playerNames);
      Navigator.of(
        context,
      ).pop(); // Return to home page which will show the next screen
    } catch (e) {
      ToastHelper.showError('Error starting game: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
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
        resizeToAvoidBottomInset: true, // Important for keyboard handling
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: const Text(
            'Setup Players',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            // Make the entire content scrollable
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Player count selector
                PlayerCountSelector(
                  playerCount: _playerCount,
                  onDecrease: _playerCount > 3
                      ? () => _updatePlayerCount(_playerCount - 1)
                      : null,
                  onIncrease: _playerCount < 12
                      ? () => _updatePlayerCount(_playerCount + 1)
                      : null,
                ),

                const SizedBox(height: 20),

                // Player name inputs
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
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Enter Player Names',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Replace ListView with Column for better scrolling
                      Column(
                        children: List.generate(
                          _playerCount,
                          (index) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: PlayerNameTextField(
                              controller: _controllers[index],
                              label: 'Player ${index + 1}',
                              hintText: 'Enter name...',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Start Game Button
                GameButton(
                  text: 'START GAME',
                  icon: Icons.rocket_launch,
                  onPressed: _startGame,
                ),

                // Add some bottom padding for keyboard
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
