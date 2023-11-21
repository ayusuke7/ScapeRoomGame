import 'package:uuid/uuid.dart';
import 'dart:io';

import '/models/player.dart';

class Server {
  final Uuid _uuid = const Uuid();

  final List<Player> players = [];
  late HttpServer _server;

  bool _started = false;
  bool get started => _started;

  void start() async {
    try {
      _server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8080);
      _server.listen(_listen);
      _started = true;
      print("Server started on ${_server.address.host}...");
    } catch(e){
      _started = false;
      print("Something went wrong when started server...");
    }
  }

  void stop() async {
    try {
      await _server.close();
      _started = false;
      players.clear();
      print('Server stopped');
    } catch (e) {
      print("Something went wrong when stopped server...");
    }
  }

  void _listen(HttpRequest request) async {
    ContentType contentType = ContentType("text", "plain", charset: "utf-8");
    Object content = '';

    if (!request.uri.path.contains('favicon')) {
      var params = request.requestedUri.queryParameters;
      var player = Player.fromJson(params);
      
      updatePlayer(player);

      content = player.log;
    }

    request.response
      ..headers.contentType = contentType
      ..write(content)
      ..close();  
  }

  void addPlayer(Player player) {
    if (player.uuid == null || player.uuid!.isEmpty) {
      player.uuid = _uuid.v4();
    }
    players.add(player);
    print('client addeded: ${player.uuid}');
  }

  void updatePlayer(Player player) {
    var index = players.indexWhere((c) => c.uuid == player.uuid);
    if (index > -1) {
      players[index] = player;
      print('player updated: ${player.uuid}');
    } else {
      addPlayer(player);
    }
  }

}