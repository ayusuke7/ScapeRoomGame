import 'package:flutter/material.dart';
import 'package:flutter_multiplayer/models/player.dart';
import 'package:uuid/uuid.dart';

class PlayersStore extends ValueNotifier<List<Player>> {
  final Uuid _uuid = const Uuid();

  PlayersStore() : super([]);

  void addPlayer(Player player) {
    if (player.uuid == null || player.uuid!.isEmpty) {
      player.uuid = _uuid.v4();
    }
    value = List.from(value)..add(player);
    print('client addeded: ${player.uuid}');
  }

  void updatePlayer(Player player) {
    var index = value.indexWhere((c) => c.uuid == player.uuid);
    if (index > -1) {
      var copy = List<Player>.from(value);
      copy[index] = player;
      value = copy;
      print('player updated: ${player.uuid}');
    } else {
      addPlayer(player);
    }
  }

  void removePlayer(Player player) {
    var index = value.indexWhere((c) => c.uuid == player.uuid);
    if (index > -1) {
      var copy = List<Player>.from(value);
      copy.removeAt(index);
      value = copy;
      print('player removed: ${player.uuid}');
    }
  }

  void clear() {
    value = List.empty();
  }

  Player getPlayer(String uuid) {
    return value.firstWhere((p) => p.uuid == uuid);
  }
  }