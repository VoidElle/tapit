import 'package:flutter/material.dart';

import '../widgets/game_local_count_down.dart';
import '../widgets/game_local_gesture_detectors.dart';
import '../widgets/game_local_new_ready_buttons.dart';
import '../widgets/game_local_player_containers.dart';
import '../widgets/game_local_player_percentages.dart';
import '../widgets/game_local_win_confetti.dart';

class GameLocalPage extends StatelessWidget {

  static const String route = "/game-local-page";

  const GameLocalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(
        children: [


          GameLocalPlayersContainers(),

          GameLocalPlayersPercentages(),

          GameLocalCountDown(),

          GameLocalWinConfetti(),

          GameLocalGestureDetectors(),

          GameLocalNewReadyButtons(),

        ],
      ),
    );
  }
}
