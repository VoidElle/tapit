import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tapit/game/online/enums/socket_enums.dart';
import 'package:tapit/game/online/models/game/game_online_game_model.dart';
import 'package:tapit/game/online/models/lobby/game_online_lobby_model.dart';
import 'package:tapit/game/online/providers/game_online_game_provider.dart';
import 'package:tapit/game/online/utils/game_online_functions.dart';
import 'package:tapit/global/utils/global_functions.dart';

import 'package:socket_io_client/socket_io_client.dart' as socket_io;

import '../models/player/game_online_player_model.dart';
import '../pages/lobby/new_game_online_lobby_page.dart';

mixin GameOnlineSocketLobbyCreationListenerMixin {

  void listenToSocketLobbyCreationEvent(BuildContext context, socket_io.Socket? socket, WidgetRef ref) {

    // Function that will be execute if the server send the lobby creation
    // SUCCESS event
    socket?.on(GameOnlineSocketEvent.createLobbyResponseSuccess.text, (dynamic data) {

      if (!context.mounted) {
        return;
      }

      // Get the Game Lobby model received
      final Map<String, dynamic> jsonReceived = data as Map<String, dynamic>;
      final GameOnlineLobbyModel gameOnlineLobbyModel = GameOnlineLobbyModel.fromJson(jsonReceived);

      // Get the notifier of the OnlineGame
      final gameOnlineGameNotifier = ref.read(gameOnlineGameProvider.notifier);

      // Create the list to set
      final List<GameOnlinePlayerModel> gameOnlinePlayerModelList = GameOnlineFunctions.getPlayersFromGameOnlineLobbyModel(gameOnlineLobbyModel);

      // Create the game model
      final GameOnlineGameModel gameOnlineGameModel = GameOnlineGameModel(
          lobbyId: gameOnlineLobbyModel.lobbyId,
          players: gameOnlinePlayerModelList,
      );

      // Set the game model on the provider
      gameOnlineGameNotifier.setGameModel(gameOnlineGameModel);

      // Redirect the player to the Lobby page
      GlobalFunctions.redirectAndClearRootTree(NewGameOnlineLobbyPage.route);

    });

    // Function that will be execute if the server send the lobby creation
    // ERROR event
    socket?.on(GameOnlineSocketEvent.createLobbyResponseFail.text, (dynamic data) {
      GlobalFunctions.showErrorDialog(
        shouldPopBefore: false,
        error: "Lobby creation failed",
        content: "An error has occurred during the creation of the lobby\nPlease try again!",
      );
    });

  }

}