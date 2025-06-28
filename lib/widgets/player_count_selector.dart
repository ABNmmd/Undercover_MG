import 'package:flutter/material.dart';

class PlayerCountSelector extends StatelessWidget {
  final int playerCount;
  final VoidCallback? onDecrease;
  final VoidCallback? onIncrease;

  const PlayerCountSelector({
    super.key,
    required this.playerCount,
    this.onDecrease,
    this.onIncrease,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
      ),
      child: Column(
        children: [
          const Text(
            'Number of Players',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: onDecrease,
                icon: const Icon(Icons.remove_circle),
                color: onDecrease != null
                    ? Colors.white
                    : Colors.white.withOpacity(0.3),
                iconSize: 32,
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$playerCount',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF667EEA),
                  ),
                ),
              ),
              IconButton(
                onPressed: onIncrease,
                icon: const Icon(Icons.add_circle),
                color: onIncrease != null
                    ? Colors.white
                    : Colors.white.withOpacity(0.3),
                iconSize: 32,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Min: 3 players • Max: 12 players',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}
