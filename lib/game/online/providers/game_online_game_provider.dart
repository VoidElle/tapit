import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tapit/game/online/models/game/game_online_game_model.dart';
import 'package:tapit/game/online/models/player/game_online_player_model.dart';
import 'package:tapit/global/providers/global_socket_provider.dart';
import 'package:tapit/global/utils/global_constants.dart';

import 'package:socket_io_client/socket_io_client.dart' as socket_io;

final gameOnlineGameProvider = StateNotifierProvider<GameOnlineGameNotifier, GameOnlineGameModel>(
      (ref) => GameOnlineGameNotifier(),
);

class GameOnlineGameNotifier extends StateNotifier<GameOnlineGameModel> {

  // Initial state of the Provider
  static final GameOnlineGameModel _initialState = GameOnlineGameModel(
    lobbyId: "",
  );

  // Constructor of the provider
  GameOnlineGameNotifier(): super(GameOnlineGameModel.fromJson(_initialState.toJson()));

  // Function to set the game model
  void setGameModel(GameOnlineGameModel gameModel, { notify = true }) {
    if (notify) {
      state = gameModel;
    } else {
      state.players = gameModel.players;
    }
  }

  // Function to retrieve a player from its socket id
  GameOnlinePlayerModel? getPlayer(String? socketId) {

    if (socketId == null) {
      return null;
    }

    final int position = _getPositionOfSocketIdInState(socketId);

    if (position == -1) {
      return null;
    }

    return state.players[position];
  }

  // Function to get the position of a socket in the current state from its socket id
  int _getPositionOfSocketIdInState(String socketId) {
    int i = 0;
    for (GameOnlinePlayerModel gameOnlinePlayerModel in state.players) {
      if (gameOnlinePlayerModel.gameOnlineSocketModel.socketId == socketId) {
        return i;
      }
      i++;
    }
    return -1;
  }

  // Function to change a player's ready status using its socket id
  void changeReadyStatus(String socketId) {

    final List<GameOnlinePlayerModel> newPlayersList = [...state.players ];

    for (GameOnlinePlayerModel gameOnlinePlayerModel in newPlayersList) {
      if (gameOnlinePlayerModel.gameOnlineSocketModel.socketId == socketId) {
        gameOnlinePlayerModel.readyStatus = !gameOnlinePlayerModel.readyStatus;
        break;
      }
    }

    final GameOnlineGameModel newState = GameOnlineGameModel(
      lobbyId: state.lobbyId,
      players: newPlayersList,
    );

    state = newState;
  }

  // Function to retrieve if a player is leader from its socket id
  bool isSocketLeader(String socketId) {

    final GameOnlinePlayerModel? gameOnlinePlayerModel = getPlayer(socketId);

    if (gameOnlinePlayerModel == null) {
      return false;
    }

    return gameOnlinePlayerModel.gameOnlineSocketModel.isLeader;
  }

  // Function to score
  void score({
    required String attackerSocketId,
    required String victimSocketId,
    required WidgetRef ref,
  }) {

    // Get the attacker's position inside the state
    final int scoredSocketIdPosition = _getPositionOfSocketIdInState(attackerSocketId);
    final int victimSocketIdPosition = _getPositionOfSocketIdInState(victimSocketId);

    // Get the attacker and the victim player's model
    // Attacker -> identified by the position given from the "_getPositionOfSocketIdInState" function
    // Victim -> Considering that in a game there are only 2 players, if the index of the attacker is 0,
    //           the victim must be in the index 1, or vice versa
    final GameOnlinePlayerModel attackerPlayerModel = state.players[scoredSocketIdPosition];
    final GameOnlinePlayerModel victimPlayerModel = state.players[victimSocketIdPosition];

    attackerPlayerModel.percentageValue += 5;
    victimPlayerModel.percentageValue -= 5;

    GlobalConstants.logger.i(
        """
        ==================================================
        Incrementing socket ${attackerPlayerModel.gameOnlineSocketModel.socketId}
        Decrementing socket ${victimPlayerModel.gameOnlineSocketModel.socketId}
        ==================================================
        """
    );

    // Create and set a new state
    final GameOnlineGameModel newState = GameOnlineGameModel.fromJson(state.toJson());
    state = newState;

    // If the attacker has won, emit the win event
    if (attackerPlayerModel.percentageValue == 100) {
      final socket_io.Socket socket = ref.read(globalSocketProvider).socket!;
      GlobalConstants.gameOnlineSocketEmitter.emitGameWinEvent(
        socket: socket,
        lobbyId: state.lobbyId,
      );
    }

  }

}