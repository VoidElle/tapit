
// Enum for managing the state of the Socket
enum GameOnlineSocketStatus {
  toInit,
  loading,
  success,
  error,
  disconnected
}

// Enum for managing the events with the server
enum GameOnlineSocketEvent {
  connection,
  disconnect,
  createLobby,
  joinLobby,
  joinSuccess,
  joinFail,
  score,
  getSocketsInfo,
  setReadyStatus,
}

// Extension to transform the enum to String using .text
extension GameOnlineSocketEventExtension on GameOnlineSocketEvent {

  String get text {
    switch(this) {
      case GameOnlineSocketEvent.connection:
        return "connection";
      case GameOnlineSocketEvent.disconnect:
        return "disconnect";
      case GameOnlineSocketEvent.createLobby:
        return "create_lobby";
      case GameOnlineSocketEvent.joinLobby:
        return "join_lobby";
      case GameOnlineSocketEvent.score:
        return "score";
      case GameOnlineSocketEvent.joinSuccess:
        return "join_success";
      case GameOnlineSocketEvent.joinFail:
        return "join_fail";
      case GameOnlineSocketEvent.getSocketsInfo:
        return "get_sockets_info";
      case GameOnlineSocketEvent.setReadyStatus:
        return "set_ready_status";
    }
  }

}