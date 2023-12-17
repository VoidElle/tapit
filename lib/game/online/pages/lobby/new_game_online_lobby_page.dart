import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as socket_io;
import 'package:tapit/game/online/widgets/new/lobby/new_game_online_lobby_players_list.dart';
import 'package:tapit/global/utils/global_constants.dart';

import '../../../../global/providers/global_socket_provider.dart';
import '../../../../global/utils/global_color_constants.dart';
import '../../../../global/utils/global_functions.dart';
import '../../../../menu/pages/menu_page.dart';
import '../../../../global/widgets/global_custom_container_base.dart';
import '../../models/game/game_online_game_model.dart';
import '../../providers/game_online_game_provider.dart';
import '../../widgets/new/new_game_online_back_home_buttons.dart';
import 'new_game_online_page.dart';

class NewGameOnlineLobbyPage extends ConsumerWidget {

  static const route = "/new-game-online-lobby-page";

  const NewGameOnlineLobbyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final double usableScreenHeight = mediaQuery.size.height - mediaQuery.padding.top;

    final GameOnlineGameModel gameOnlineGameState = ref.read(gameOnlineGameProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: usableScreenHeight,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [

                GlobalCustomContainerBase.big(
                  backgroundColor: GlobalColorConstants.kRedColor,
                  text: gameOnlineGameState.lobbyId,
                  lineHeight: 0.85,
                  fontSize: 60,
                  fontStrokeWidth: 8,
                  letterSpacing: 7.5,
                  callback: () async {
                    await Clipboard.setData(
                      ClipboardData(
                        text: gameOnlineGameState.lobbyId,
                      ),
                    );
                  },
                ),

                const Expanded(
                  child: SizedBox(),
                ),

                const NewGameOnlineLobbyPlayersList(),

                const Expanded(
                  child: SizedBox(),
                ),

                const GlobalCustomContainerBase.small(
                  margin: EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 7.5,
                  ),
                  backgroundColor: GlobalColorConstants.kBlueColor,
                  text: 'START GAME',
                  fontSize: 28,
                  fontStrokeWidth: 4,
                ),

                const GlobalCustomContainerBase.small(
                  margin: EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 7.5,
                  ),
                  backgroundColor: GlobalColorConstants.kBlueColor,
                  text: 'CHANGE READY',
                  fontSize: 28,
                  fontStrokeWidth: 4,
                ),

                SizedBox(
                  height: usableScreenHeight / 12.5,
                ),

                NewGameOnlineBackButtons(
                  backButtonCallback: () {
                    _quitLobby(ref, gameOnlineGameState);
                    GlobalFunctions.redirectAndClearRootTree(NewGameOnlinePage.route);
                  },
                  homeButtonCallback: () {
                    _quitLobby(ref, gameOnlineGameState);
                    GlobalFunctions.redirectAndClearRootTree(MenuPage.route);
                  },
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  void _quitLobby(WidgetRef ref, GameOnlineGameModel gameOnlineGameState) {
    final socket_io.Socket? socket = ref.read(globalSocketProvider).socket;
    if (socket != null) {
      GlobalConstants.gameOnlineSocketEmitter.emitQuitLobbyEvent(socket, gameOnlineGameState.lobbyId);
    }
  }

}