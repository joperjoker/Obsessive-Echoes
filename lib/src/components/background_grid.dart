import 'dart:ui';
import 'package:flame/components.dart';
import '../../core/game_config.dart';

class BackgroundGrid extends Component {
  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = GameConfig.vibrantBlue.withOpacity(0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    const spacing = 100.0;
    
    // Vertical lines
    for (double x = 0; x <= GameConfig.arenaWidth; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, GameConfig.arenaHeight), paint);
    }
    
    // Horizontal lines
    for (double y = 0; y <= GameConfig.arenaHeight; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(GameConfig.arenaWidth, y), paint);
    }
  }
}
