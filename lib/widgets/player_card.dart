import 'package:flutter/material.dart';

class PlayerCard extends StatelessWidget {
  final String playerName;
  final VoidCallback? onTap;
  final bool isViewed;
  final bool isCurrentPlayer;

  const PlayerCard({
    super.key,
    required this.playerName,
    this.onTap,
    this.isViewed = false,
    this.isCurrentPlayer = false,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color borderColor;
    String statusText;
    IconData statusIcon;

    if (isViewed) {
      backgroundColor = Colors.green.withOpacity(0.2);
      borderColor = Colors.green;
      statusText = 'Viewed';
      statusIcon = Icons.check_circle;
    } else if (isCurrentPlayer) {
      backgroundColor = Colors.orange.withOpacity(0.2);
      borderColor = Colors.orange;
      statusText = 'Your Turn';
      statusIcon = Icons.touch_app;
    } else {
      backgroundColor = Colors.white.withOpacity(0.1);
      borderColor = Colors.white.withOpacity(0.3);
      statusText = 'Waiting';
      statusIcon = Icons.access_time;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: borderColor,
              child: Text(
                playerName.isNotEmpty ? playerName[0].toUpperCase() : '?',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Flexible(
              child: Text(
                playerName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(statusIcon, color: borderColor, size: 16),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    statusText,
                    style: TextStyle(
                      fontSize: 12,
                      color: borderColor,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
