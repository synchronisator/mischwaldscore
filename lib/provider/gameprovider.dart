
import 'package:flutter/material.dart';
import 'package:mischwaldscore/pages/card.dart';
import 'package:mischwaldscore/pages/cards.dart';
import 'package:mischwaldscore/provider/player.dart';

class GameProvider extends ChangeNotifier {

  List<Player> player = [];
  int activePlayer = 0;

  void removePlayer(Player e) {
    player.remove(e);
    notifyListeners();
  }

  void addPlayer() {
    player.add(Player("Player ${player.length + 1}"));
    notifyListeners();
  }

  Player? getActivePlayer() {
    return activePlayer >= player.length ? null : player[activePlayer];
  }

  void notify() {
    notifyListeners(); //TODO HAck
  }

  // Anzahl Bäume + Anzahl Holzbiene
  int getMaxAnzahlBaeume() {
    int maxBaeume = 0;
    for (var i = 0; i < player.length; ++i) {
      var maxBaeumePerPlayer = player[i].getMaxBaeume();
      if(maxBaeumePerPlayer > maxBaeume){
        maxBaeume = maxBaeumePerPlayer;
      }
    }
    return maxBaeume;
  }

  // Anzahl Linden + Anzahl Holzbiene an Linden
  int getMaxLinden() {
    int maxLinden = 0;
    for (var i = 0; i < player.length; ++i) {
      var maxLindenPerPlayer = player[i].getMaxLinden();
      if(maxLindenPerPlayer > maxLinden){
        maxLinden = maxLindenPerPlayer;
      }
    }
    return maxLinden;
  }

  recalcPoints() {
    for (var i = 0; i < player.length; ++i) {
      player[i].calcPoints(this);
    }
    notifyListeners();
  }

  void setActivePlayer(Player e) {
    for (var i = 0; i < player.length; ++i) {
      if(e == player[i]) {
        activePlayer = i;
      }
    }
    notifyListeners();
  }

  void clear(){
    player.clear();
    notifyListeners();
  }

  void removeTree(Tree tree) {
    Player p = player[activePlayer];
    p.trees.remove(tree);
    tree.getCards().forEach((String card) {
      p.karteAnzahl[card] = p.karteAnzahl[card]! - 1;
      for (var typ in CardsExtension.asMap()[card]!.typen) {
        p.typenAnzahl[typ] = p.typenAnzahl[typ]! - 1;
        bool wasUnique = true;
        for (var i = 0; i < p.trees.length; ++i) {
          if(p.trees[i].getCards().contains(card)){
            wasUnique = false;
          }
        }
        if(wasUnique){
          p.typenUnique[typ]!.remove(card);
        }
      }
    });
    recalcPoints();
  }

}