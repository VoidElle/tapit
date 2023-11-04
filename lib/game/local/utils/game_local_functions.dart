import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/game_local_game_status_provider.dart';
import '../providers/game_local_player_data_provider.dart';

class GameLocalFunctions {

  // Function to reset the providers of the Local Game
  static void resetProviders(WidgetRef ref) {

    // Reset the providers of the match
    ref.read(gameLocalPlayerDataProvider.notifier).reset();
    ref.read(gameLocalGameStatusProvider.notifier).reset();

  }

}